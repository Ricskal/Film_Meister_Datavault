FROM python
WORKDIR /filmmeisterapp
COPY deploy_objects.py deploy_objects.py
COPY load_datavault.py load_datavault.py
COPY film_meister_datavault_main.py film_meister_datavault_main.py
COPY DDL_scripts/ DDL_scripts/
COPY DML_scripts/ DML_scripts/