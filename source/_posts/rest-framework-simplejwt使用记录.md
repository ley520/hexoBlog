---
title: rest_framework_simplejwt使用记录
date: 2023-02-03 18:01:38
tags: Django
categories:
 - [Django,jwt]
---



## 0、基本说明

[**rest_framework_simplejwt**](https://github.com/jazzband/djangorestframework-simplejwt) 是用于[**Django REST**](https://www.django-rest-framework.org/)的认证组件，用来进行用户的身份认证。

## 1、安装配置(使用默认配置)

### 安装

````python
pip install djangorestframework # 需要安装djangorestframework，simplejwt配合drf使用
pip install djangorestframework-simplejwt

注意：以下配置使用的是Django自带的用户模型，或者是通过继承django.contrib.auth.models.AbstractUser扩展的用户模型
````

### settings设置

```python
# 在settings文件中的REST_FRAMEWORK中增加 DEFAULT_AUTHENTICATION_CLASSES对应的key-value
# 如果还未配置REST_FRAMEWORK，把下面整体复制进去即可
# 此处是告诉drf 使用哪个认证器进行认证校验
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    )
}

simpleJWT的配置
SIMPLE_JWT = {
    # token过期时间
    'ACCESS_TOKEN_LIFETIME': timedelta(days=3),
    # token刷新过期时间
    'REFRESH_TOKEN_LIFETIME': timedelta(days=5),

    'ROTATE_REFRESH_TOKENS': False,
    'BLACKLIST_AFTER_ROTATION': False,
    # 更新user表的最后登录时间，不建议打开
    'UPDATE_LAST_LOGIN': False,
    # token加密方法
    'ALGORITHM': 'HS256',
    # token加密的key
    'SIGNING_KEY': SECRET_KEY,
    'VERIFYING_KEY': None,
    'AUDIENCE': None,
    'ISSUER': None,
    'JWK_URL': None,
    'LEEWAY': 0,
    # token拼接方法： Bearer token
    'AUTH_HEADER_TYPES': ('Bearer',),
    # 从哪个header获取token，注意 HTTP_ 这个前缀不要丢弃。如非必要不要改动
    'AUTH_HEADER_NAME': 'HTTP_AUTHORIZATION',
    'USER_ID_FIELD': 'id',
    'USER_ID_CLAIM': 'user_id',
    'USER_AUTHENTICATION_RULE': 'rest_framework_simplejwt.authentication.default_user_authentication_rule',

    'AUTH_TOKEN_CLASSES': ('rest_framework_simplejwt.tokens.AccessToken',),
    'TOKEN_TYPE_CLAIM': 'token_type',
    'TOKEN_USER_CLASS': 'rest_framework_simplejwt.models.TokenUser',

    'JTI_CLAIM': 'jti',

    'SLIDING_TOKEN_REFRESH_EXP_CLAIM': 'refresh_exp',
    'SLIDING_TOKEN_LIFETIME': timedelta(minutes=5),
    'SLIDING_TOKEN_REFRESH_LIFETIME': timedelta(days=1),
}

```

### URL配置

```python
# 此库提供了两个视图，用来进行获取token(登录)，刷新token(延长token有效期)
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
   TokenVerifyView
)

urlpatterns = [
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'), # 登录接口，返回token信息，也可以把url替换成容易理解的login/
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'), # 延长token有效期
    path('api/token/verify/', TokenVerifyView.as_view(), name='token_verify'), # 验证token
]
```

### 测试一下

```shell
1、创建用户
2、测试
curl --location --request POST 'http://127.0.0.1:8888/login/' \
--header 'User-Agent: Apifox/1.0.0 (https://www.apifox.cn)' \
--header 'Content-Type: application/json' \
--data-raw '{
    "username": "用户名",
    "password": "密码"
}'
响应信息
 {
    "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY3NTg1NDEyMiwiaWF0IjoxNjc1NDIyMTIyLCJqdGkiOiI0MDNiYTQ2N2VkNGU0ODllYmI2MWNlMjU5OTVkMTM3NiIsInVzZXJfaWQiOjF9.4tmyp53OSdmeo87KP-rNNlqUInFzbVSd7Dug3m3tu-A",
    "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjc1NjgxMzIyLCJpYXQiOjE2NzU0MjIxMjIsImp0aSI6ImQwODRkZjlkMzMxZjQ4NjNhZWQyM2I1NjkwYjgxNmY2IiwidXNlcl9pZCI6MX0.mvRWtThlAU8-Kg79Dv2Q1vYbB10M7vz11vJoliLiOKE"
}
3、后续使用
在接口请求时，需要在header中添加两个kev-value
{
'Content-Type: application/json',
'Authorization': Bearer(注意这里有空格) 响应信息中的access
}
```

## 2、自定义token信息返回

### 继承并重写序列化器

```python
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.settings import api_settings
from django.contrib.auth.models import update_last_login
class MyTokenObtainPairSerializer(TokenObtainPairSerializer):

    def validate(self, attrs):
        data = super().validate(attrs)

        refresh = self.get_token(self.user)

        data["refresh"] = str(refresh)
        data["access"] = str(refresh.access_token)
        # 以下两个是自定义返回
        data["user_id"] = self.user.id
        data["username"] = self.user.username

        if api_settings.UPDATE_LAST_LOGIN:
            update_last_login(None, self.user)

        return data
```

### 继承并重写视图

```python
from rest_framework_simplejwt.serializers import TokenRefreshSerializer
import MyTokenObtainPairSerializer
class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer
```

### 配置URL

```python
path('mylogin/', MyTokenObtainPairView.as_view(), name='login'),
```

### 测试

```python
curl --location --request POST 'http://127.0.0.1:8888/mylogin/' \
--header 'User-Agent: Apifox/1.0.0 (https://www.apifox.cn)' \
--header 'Content-Type: application/json' \
--data-raw '{
    "username": "admin",
    "password": "admin"
}'
响应信息
{
    "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY3NTkwNTQ2MSwiaWF0IjoxNjc1NDczNDYxLCJqdGkiOiI2YzBlNjA0YjU3OGM0ZDUzYmJjNzBlNmZjNzliZmYxZSIsInVzZXJfaWQiOjF9.hhx-yWM5OlLexndv9-GVJgUn5PyfKnASVLPb7v7MyTg",
    "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjc1NzMyNjYxLCJpYXQiOjE2NzU0NzM0NjEsImp0aSI6ImRmZjJjODEyMGRjYTQyYTA4NjJmZDNjYmQ2OTFkOTAzIiwidXNlcl9pZCI6MX0.4IfdjH_3JCb3K0qAQu1KnpoxIOH8TpYGh15Os-R4VTI",
    "user_id": 1,
    "username": "admin"
}
```

## 3、在代码中获取用户信息

```python
from rest_framework.views import APIView


class TestApi(APIView):

    def get(self, request, *args, **kwargs):
       # 当前请求的用户，是user表中的一个对象
       print(request.user)
        # 获取用户的id
        print(request.user.pk)
        # token中的信息，包含自定义的信息
        print(request.auth)
        return Response({"msg": "test"})

```
