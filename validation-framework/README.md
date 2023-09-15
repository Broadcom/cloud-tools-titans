# Validation framework

## Working directory
* All commands running under the same directory of this **README.md**

## Prepare your test environment
* Copy values.yaml from your service helm chart here
* Modify values-test.yaml to change default images for your test environment
* Download the desired umbrella helm chart here
  
## Build test environment
* run ./build.sh with required umbrella chart name and chart version, see example command
```bash
./build.sh icds-all-in-one 1.203.48
```

## Run it up
```bash
docker-compose up
```
## Authors

* **Anker Tsaur** - *anker.tsaur@broadcom.com**

