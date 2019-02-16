## Welcome to AZX.ms

<img src="https://github.com/ashleymcnamara/Developer-Advocate-Bit/blob/master/data.png" style="width:80px">

This utility is intended to help you create the scripts you need for Microsoft Azure. You can [browse them online](https://azx.ms) or install a quick utility function. 

## Setup

The easiest thing to do is to use the command line:

### Mac & Linux (bash)
```sh
echo "function azx() { curl -sL https://azx.ms/api/\$1;}" >> ~/.bashrc && source ~/.bashrc

azx
```
### Mac & Linux (zshell)
```sh
echo "function azx() { curl -sL https://azx.ms/api/\$1;}" >> ~/.zshrc && source ~/.zshrc

azx
```

## Use

To find out what scripts we have you can browse the site (at https://azx.ms) or use `azx list`:

```
azx list

#### The Basics ####

help | The basics of AZX and how to use it.
list | Don't know what you're looking for? Here's a list
mysql | Creating an Azure Database for MySQL on Azure.
postgres | Pushing Azure Database for PostgreSQL to Azure.
webapp_container | Create a Web App using a container
webapp_git | Create a Web App and deploy using Git

#### AZX Recipes ####

ghost | Create a super scalable Ghost blog on Azure using Web Apps for Containers and hosted MySQL
pg_migrate | Migrate an existing PostgreSQL database to Azure's SQL Database for PostgreSQL
wordpress | Create a super scalable Wordpress site on Azure using Web Apps for Containers and hosted MySQL 
```

WHen you see a script you want to use, just call it directly:

```
azx postgres
```

This will splash the script into the terminal. If you want to put it into a file (recommended), just redirect STDOUT:

```
azx postgres > azure_pg.sh
```

Now open up the script in an editor, change what you need (usually just variables at the top) and off you go!

## Have a Script for Us? Or a Request?

Feel free to leave an issue or drop a PR. Take a look at the `_api` and `_recipes` directory and decide where you think your script should go. The `_api` directory is supposed to be for basic things, like creating a simple web app or a database. The `_recipes` directory is a bit more end to end.

Please follow the format and conventions you see there, including adding your name a description. **Please be sure your script works!**

Thanks!

