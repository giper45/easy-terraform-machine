# terraform-recipes
Terraform recipes for most common environments

## How it works  
Terraform is an awesome environment to execute virtual machines.
The prjoect aims to provide basic terraform recipes to configure single virtual instances in all the environments.
Depending on your needs you can use them and customize them.

You need to configure the authentication APIs to use the environments. Each section in the `README` provides you information about how to perform it (see the Prequirements section)


### Setup the variables
In order to use the recipes you need to: 
1. Setup the authentication tokens
2. Configure the environment variables

You can have two alternative: use the `.bashrc` (or `.zshrc`) environment variable, or create a `.env` file and configure as you need. 

```
cp .env.tpl .env ; 
# Change variables and source it
source .env
```

## Cloud Providers 
There is support for `AWS`, `DigitalOcean` and `Azure` providers.
Feel free to contribute by adding further environments.


### AWS 
Used provider:  https://github.com/hashicorp/terraform-provider-aws
#### Authentication 
You have to create Access key and secret key with proper permissions. 
Install the `awscli` and follow the guide. 


#### Available variables
#### Find variables
* List AMIs: 
```
aws ec2 describe-images --owners amazon --query 'Images[*].{ID:ImageId,Name:Name}' --output table
```
it a long process, you should filter results, i.e.: 
```
aws ec2 describe-images --owners amazon --query 'Images[*].{ID:ImageId,Name:Name}' --filters "Name=name,Values=ubuntu*" --output table
```

You also have several commands for specific distros:
For ubuntu you can check here: 
https://cloud-images.ubuntu.com/locator/ec2/



### Digital Ocean 
Used provider: https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs


#### Authentication
To use recipes, setup the `DIGITALOCEAN_TOKEN` in environment variables  (`API > Applications & API > Tokens/Keys > Generate New Token.`)
```
export DIGITALOCEAN_TOKEN="dop..."
```

#### Available variables     


* `do_key_id`: the Digital Ocean public key id that you can upload in the Digital Ocean account (https://docs.digitalocean.com/products/droplets/how-to/add-ssh-keys/to-team/)
* `do_name`: the droplet name 
* `do_image`: the droplet image
* `do_size`: the droplet size 



#### Find variables
Install the [doctl](https://docs.digitalocean.com/reference/doctl/how-to/install/) CLI .

* List available images: 

```
doctl compute image list-distribution # for operating systems
doctl compute image list # for applications
```

* List executed droplets 
```
doctl compute droplet list
```

* List SSH key id: 
```
doctl compute ssh-key list
``` 
The first column is the `do_key_id`. 

* List sizes
```
doctl compute size list
```
