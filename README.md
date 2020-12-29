
### Prerequisite
1. download and install blackbox
https://github.com/StackExchange/blackbox#alternatives

we need a way to automate gpg key creation

```
export PROJECT=agora
export SCOPE=staging
export ADMIN=quentin@$PROJECT
export DEPLOYER=${SCOPE}_deployer@$PROJECT
```

1. create a pub/priv key for an admin
   your email could be *firstname@foo.com*
   your password could be `openssl rand -base64 30`
`gpg --gen-key`

store the private key and password somewhere secure

2. create a passwordless pub/priv key for the deploy user
a. 
```
gpg --gen-key
# Real name: $PROJECT $SCOPE Deployer
# Email address: $DEPLOYER
```

b. create a subkey
```
gpg --edit-key $DEPLOYER
gpg> addkey
...   (6) RSA (encrypt only)
...    0 = key does not expire
Is this correct? (y/N) y
Really create? (y/N) y

# key is created now set empty password
gpg> key 2

# the second key gets a * which means it's selected
ssb* rsa2048/B799C28A639D8F3A

gpg> password

# first enter the main key password
# then enter the empty password
# on my Mac I had to do this 3 times!gpg> save

```

c. export the secret key

This secret key need to be available on the deploy machine
```
gpg -a — export-secret-keys $DEPLOYER > $DEPLOYER.secret_key
```

d. on the deploy machine



### Create a repository with your secrets

1. init a new secret blackbox
```
export PROJECT=agora
export SCOPE=staging
export ADMIN=quentin@$PROJECT

git clone https://github.com/gaultierq/blackbox_template.git ${PROJECT}_secrets
cd ${PROJECT}_secrets
git remote rm origin

export BLACKBOXDATA=$SCOPE
yes | blackbox_initialize
git commit -am'init blackbox' 

# add myself as an admin
blackbox_addadmin $ADMIN
git commit -am "add first admin" 

# add deployer to blackbox admin
blackbox_addadmin $DEPLOYER
git commit -m "add $DEPLOYER as admin" -a


echo "#secret file for #SCOPE" > $SCOPE.env
blackbox_register_new_file $SCOPE.env
git add .
```

& publish on your git repo






source :
https://medium.com/@mipselaer/gitlab-ci-blackbox-526c7ad7bec0