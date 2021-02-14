### UPDATE MAKEFILE

**1.** To possible start using this docker4drupal local environment instance, update the Makefile:

- Update all the strings with {PRODUCT_NAME} to your desired name.

### UPDATE docker-compose.yml

**1.** To possible start using this docker4drupal local environment instance, update the Makefile:

- Update all the variables created on makefile with string {PRODUCT_NAME} inside the docker-compose.yml

### RUN Docker

**1.** To possible run and setup local docker environment:

- Ensure to run make setup to populate the .env file.
- run make start to possible execute docker containers.
- Create the host to access your site inside etc/hosts file pointing to IP.
  - Example: 172.19.0.123 dev.project-name.com.br

**2.** Copy drupal installation files to docroot folder.

**3.** After the setup finishes and you configured Drupal and the DB, check your environment on the configured Host.
