# Packer images for GCP

```                                                                                                                                    __________    ____ |  | __ ___________  \_ |__ _____    ______ ____   |__| _____ _____     ____   ____   ______
\____ \__  \ _/ ___\|  |/ // __ \_  __ \  | __ \\__  \  /  ___// __ \  |  |/     \\__  \   / ___\_/ __ \ /  ___/
|  |_> > __ \\  \___|    <\  ___/|  | \/  | \_\ \/ __ \_\___ \\  ___/  |  |  Y Y  \/ __ \_/ /_/  >  ___/ \___ \ 
|   __(____  /\___  >__|_ \\___  >__|     |___  (____  /____  >\___  > |__|__|_|  (____  /\___  / \___  >____  >
|__|       \/     \/     \/    \/             \/     \/     \/     \/           \/     \//_____/      \/     \/  
 
Build packer GCE images for Google Cloud
 
 
Usage: make [TARGET]... [MAKEVAR1=SOMETHING]...

Available targets:
build                           Build a packer image for GCP Compute Engine
_build_debug                    Build a packer image for GCP Compute Engine with debug enabled
validate                        Validates a packer template
clean                           Delete the values in .envy.mk
help                            This help target

```
## Quick start
Create a service account in a project and assign the below roles

- Compute Network Admin
- roles/compute.admin, 
- roles/iam.serviceAccountUser, 
- roles/iam.serviceAccountAdmin

``` 
ROLE
roles/compute.admin
roles/compute.networkAdmin
roles/iam.roleAdmin
roles/iam.serviceAccountAdmin
roles/iam.serviceAccountUser
roles/resourcemanager.organizationAdmin
roles/resourcemanager.projectDeleter

```

and store it at 
/Users/<username>/.config/gcloud/service_accounts/<SERVICEACCOUNT-NAME>-<ORG-NAME>.json

- find roles for an existing Service account in your project

```

╰─ gcloud projects get-iam-policy <PROJECT-ID>  \                                                                                  ─╯
--flatten="bindings[].members" \
--format='table(bindings.role)' \
--filter="bindings.members:<SERVICE-ACCOUNT-ID>"

```

## CORE OS releases GCP 

https://stable.release.core-os.net/amd64-usr/current/coreos_production_gce.txt

## Errors

1. Waiting for creation operation to complete
   
```
    googlecompute: Waiting for creation operation to complete...
==> googlecompute: Error creating instance: time out while waiting for instance to create
```

- Solution : 

        Google Compute Engine instances use default services account to have a better integration with Google Platform.

        As you can read on the documentation [1]: "(...)If the user will be managing virtual machine instances that are configured to run as a service account, you must also grant the roles/iam.serviceAccountActor role."

        You need to add the role 

        - roles/compute.admin, 
        - roles/iam.serviceAccountUser, 
        - roles/iam.serviceAccountAdmin

        to your service account in order to be able to create Google Compute Engine instances.

        https://stackoverflow.com/questions/48717979/cannot-create-image-with-packer-in-google-cloud-due-to-service-account-error


        In what scenarios would I use the Service Account Actor role?
        The Service Account Actor role has been deprecated. If you need to run operations as the service account, use the Service Account User role.