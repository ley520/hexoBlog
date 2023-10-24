---
title: django使用django-guardian进行权限控制
date: 2023-02-10 10:24:22
tags: django
categories:
 - [django,django-guardian,权限]
---

## 0、说明

**[Django Object Permission之Django-guardian使用详解_大江狗的博客-CSDN博客](https://blog.csdn.net/weixin_42134789/article/details/105963583)**

**本人在学习时参考了各位前辈大佬的文章，特在此附上连接并说明，感谢各位无私分享**

Django已经集成了表级权限的控制，如果想实现行级(对象级)权限的控制，需要自己进行改动实现，也可以借助一些三方库，本次介绍的是借助django-guardian进行行级权限控制。

**由于目前只进行了简单的使用，所以本文只是记录一下使用过程，我使用的版本是2.4.0**

## 1、安装配置

### 安装

```shel
# 使用pip安装最新版
pip instlal django-guardian
```

### 配置

```python
# 在项目的settings文件中
INSTALLED_APPS = (
    # ...
    'guardian',
)
# 如果没有该配置项进行添加即可
AUTHENTICATION_BACKENDS = (
    'django.contrib.auth.backends.ModelBackend', # this is default
    'guardian.backends.ObjectPermissionBackend',
)
```

### 重新生成数据库文件

```shell
# 执行下面两个命令，会重新生成迁移文件并在数据库创建表
python manage.py makemigrations 
python manage.py migrate 
# 数据库里多了两张表guardian_groupobjectpermission和guardian_userobjectpermission，两个表分别记录了用户/组与model以及model内的具体object的权限对应关系
```

## 2、权限使用

```python
# 创建一个项目django-demo
# 创建一个app叫做demo1
django-demo
  -- django-demo
  -- demo1
    -- models.py
    -- views.py
    -- ...
    
# 在models.py 新增一个model。每个model在创建的时候会默认分配四个基本权限('add', 'change', 'delete', 'view')
class Conn(BaseModel):
    name = models.CharField(max_length=128, null=False, blank=False, unique=True, db_index=True)
    type = models.CharField(max_length=20, choices=ConnectTypeEnum.choices, null=False, blank=False)
    connect_param = models.TextField(null=False, blank=False)
    user_id = models.IntegerField()
    class Meta:
        db_table = 'connect'
        
# 重新生成信息的数据库文件并生成表
python manage.py makemigrations 
python manage.py migrate 

# 在view视图中使用，我这里是集成了drf的视图，大家不用关注类视图的集成，只需关系权限使用即可
# 本次项目使用基本权限
class ConnectionViewDetailApi(GenericAPIView):
    serializer_class = ConnectionSerializer
    queryset = Conn.objects.all()
    pagination_class = Pagination

    # permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
      	# 引入权限分配函数
        from guardian.shortcuts import assign_perm
    		# 查询一个model
        instance = Conn.objects.get(id=1)
      	# 给用户分配当前model的权限权限,  
        # demo1:app名称，view:查看的权限，conn：定义的mode名称，注意全小写
        # request.user：当前登录的用户，也可以使用User.obejects.get()查询任意你想要给权限的用户
        # instance：表里面的一行数据实例
        assign_perm('demo1.view_conn', request.user, instance)
        print(request.user.has_perm('demo1.view_conn', instance)) # 输出True
        print(request.user.has_perm('connection.change_conn', instance)) # 输出False
        serializer = self.get_serializer(queryset)
        return Response(serializer.data, status=status.HTTP_200_OK)


```



























