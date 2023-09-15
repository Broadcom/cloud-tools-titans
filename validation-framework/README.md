# Validation framework

## Working directory
* All commands running under the same directory of this **README.md**

## Prepare your test environment
* Copy values.yaml from your service helm chart here
* Modify values-test.yaml to change default images for your test environment
* Download the desired icds-all-in-one helm chart here
  
## Build test environment
```bash
./build.sh
```

## Run it up
```bash
docker-compose up
```
## Authors

* **Anker Tsaur** - *anker.tsaur@broadcom.com**

