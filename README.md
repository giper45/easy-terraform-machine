<div>
    <img src="https://raw.githubusercontent.com/giper45/easy-terraform-machine/main/docs/logo.png" alt="Eeasy Terraform Machine logo" title="Easy Terraform" align="right" height="90" />
</div>

# Easy Terraform Machine
The easiest way to run a cloud machine with Terraform. 

## How it works  
Terraform is an awesome environment to execute virtual machines.
The project aims to provide basic terraform recipes to configure single virtual instances in all the environments.
Depending on your needs you can use them and customize them.

You need to configure the `authentication APIs` to use the environments. Each section in the `README` provides you information about how to perform it (see the `Authentication` section)


### Setup the variables
Just two things:
1. Setup the authentication tokens
2. Configure the environment variables (use the `.bashrc`, `.zshrc` environment file, or just  `env` file and configure as you need:

```
cp env.tpl env ; 
# Change variables and source it
source env
```
<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Cloud Providers 
There is support for `AWS`, `DigitalOcean` and `Azure` providers.
Feel free to contribute by adding further environments.


### AWS 
Used provider:  https://github.com/hashicorp/terraform-provider-aws
#### Authentication 
You have to create Access key and secret key with proper permissions. 
Install the `awscli` and follow the guide. 


#### Available variables 
* `ssh_public_key` : the public key used to access to the machine 
* `aws_region` : the AWS region
* `aws_ami` : the AWS ami


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


You can also simply go in the `AWS` interface and try to start a new machine, and take a look at the AWS AMI: 
```
https://eu-west-1.console.aws.amazon.com/ec2/home?region=eu-west-1#LaunchInstances:
```

### Azure 
Used provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs


#### Authentication 

1. `az login` to authorize Azure. 

To check if everything is ok, send the following: 
```
az account show
```
it should show the following information: 
```
{
  "environmentName": "AzureCloud",
  "homeTenantId": "...",
  "id": "...", # NOTE: This is the subscription
  "isDefault": true,
  "managedByTenants": [],
  "name": "Azure per studenti",
  "state": "Enabled",
  "tenantId": "2fcfe26a-bb62-46b0-b1e3-28f9da0c45fd",
  "user": {
    "name": "<username>",
    "type": "user"
  }
}
```

Take note for the `id` field: it is the `subscription ID`. 

2. Then, create the service principal by following the Azure documentation: 
```
https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-bash?tabs=bash#create-a-service-principal
```

The command to create it is: 
```
az ad sp create-for-rbac --name terraform  --role Contributor --scopes /subscriptions/9c4a6c7d-6adc-4225-8635-3cf956e775fe
```

Store the information in environment variable: 
```
export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="2fcfe26a-bb62-46b0-b1e3-28f9da0c45fd"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"
```


#### Available variables 
* `ssh_public_key` : the public key used to access to the machine 



#### Find variables 
* List images: 
```
az vm image list --all --publisher Canonical

```


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
<p align="right">(<a href="#readme-top">back to top</a>)</p>

# Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
# License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>





