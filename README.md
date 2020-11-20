# Integrate DataShare with an Oauth provider

This repo contains a demo about how to integrate DataShare with an Oauth2 provider (Keycloak).

## TL;DR

```
cd datashare-keycloak-integration
docker-compose up -d
docker run --rm -ti --network datashare-keycloak-integration_intranet icij/datashare:8.1.5 -m CLI --createIndex leak1
xdg-open http://datashare:8080/
```

In the browser follow these steps:

  1. Press the button: "Login with account".
  2. Use "example" as user and password in the login form.
  3. You are in.

## Privacy warning

This demo overrides your DNS configuration to be able to reach some local services using its name,
take into consideration it changes your default DNS server to 8.8.8.8 while using the demo.

If you need to set your DNS server or don't trust on 8.8.8.8 DNS servers please change it in the `docker-compose.yml` following [DPS documentation](http://mageddo.github.io/dns-proxy-server/latest/en/3-configuration/)

## Description of the moving parts

### DataShare

This demo deploys DataShare with its dependencies as if it were deployed in a production grade environment but does not takes any care of the security. It is also logging in debug mode, it is just a demo, **do not use in production**.

The deployed dependencies are:

* Redis, for the sessions and work queues.
* ElasticSearch, to index the documents.
* PostgreSQL, to handle some persientence needed by DataShare

DataShare is configured via command options to use those services and Keycloak.

### Keycloak

Is an open source identity and access management wich supports Oauth2 for single sing on.
We are using Keycloak because it is well documented and easy to use, but you may use any Oauth2 provider.

The demo preseeds a Keycloak domain with data, so you don't need to create any application or user.

The demo deploys a Postgres server for the Keycloak persistence

### DNS

The demo overwrites the user's system DNS configuration to enable the user to access containers using the same address they have in the docker network. This is a requirement of the Oauth authorization flow: using the same addresses in the application and in the user browser.

You can also remove all the DNS specific configuration from the `docker-compose.yml` and add to `/etc/hosts` `keycloak` and `datashare`.

## Steps to manually reproduce the demo

The aim of the demo is to integrate DataShare with an Oauth provider, any other steps are omitted.

1. Ensure the demo is off with `docker-compose down`.
2. Clean the environment to ensure there is no preseeded data, run:
   ```
   docker rm datashare-keycloack-integration_kc-postgres_1 datashare-keycloack-integration_ds-postgres_1
   docker volume rm datashare-keycloack-integration_ds-postgres datashare-keycloack-integration_kc-postgres
   ```
3. In the docker-compose file comment all Keycloak command options beginning with `-Dkeycloak.migration`.
4. Fire up Keycloak `docker-compose up -d keycloak`
5. Wait few seconds and go to http://keycloak:9080/ in your browser
6. Login using *admin@icij.org* as user and *icijpassword* as password (this is defined in the docker-compose file, you can change them)
7. In the left navigation panel go to clients, then click on the create button on the upper right.
8. Fill the form with:

    * Client ID: datashare
    * Root URL: http://datashare:8080/auth/callback

9. Save
10. Set Access Type to: Confidential then save
11. click on mappers tab
12. Add these mappings:
    | Name | Maper type | Property| Token Claim Name | Claim Json Type | Full group path |
    | - | - | - | - | - |
    | email | User property | Email | email| string | - |
    | datashare_projects | datashare-project | Group Membership | - | - | Off |
    | id | User property | id | uid | string| - |
    | name | User property | Username | name | string | - |
13. Go to installation tab, select Keycloak OIDC JSON and write down the secret (it might look like an UUID)
14. Change the value of DataShare's oauthClientSecret option in the docker compose file to the new secret.
15. Get back to Keycloak administration web
16. In the left navigation panel go to Groups and create some random groups. These groups will be mapped to available projects into datashare.
17. for each created group, then create the related index with : 
```
docker run --rm -ti --network datashare-keycloak-integration_intranet icij/datashare:8.1.5 -m CLI --createIndex <index_name>
```
18.  In the left navigation panel go to users create a new user. 
19. After saving go to credentials tab and set a non temporary password for the user. Save it you'll need it.
20. Then go to the groups tab and add the user to some groups.
21. Sign out using the upper right user menu.
22. As we are using the default realm (master), instead of the seeded one (main) you will need to change the URLS for the following DataShare options in the docker compose file, just replace *main* with *master* in the provided URLS for:
  * oauthAuthorizeUrl
  * oauthTokenUrl
  * oauthApiUrl
23. Fire up DataShare with `docker-compose up datashare`
24. Wait for a few and open your browser with http://datashare:8080 and follow de authentication flow.

