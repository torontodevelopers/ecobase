# ECOBASE
---
This package contains scripts that allow for the copying and manipulation of data from within the EES database. Functions that can be performed:
- copy over the entire database from the EES Eco Service 1.7 API, and stores it in a local SQLite flat file database.
- run weekly inventory management audit
- run daily text messaging reminder
- run hourly sales reporting
- generate SaveOnEnergy invoices
- service work order statistics
- sales forecasting
- feed a small RAILS website

## Instructions
--
1. Set username and password in config.yaml for EES API access
2. Set root working directory in config.yaml
3. All empty tables have their associated methods commented out.

### Relations
---

CustomerProduct.CustomerProductDescriptionId = InstallationScheduler.ApplicationNumberId

