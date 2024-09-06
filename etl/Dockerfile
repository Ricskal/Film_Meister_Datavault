FROM python
WORKDIR /filmmeisterapp
COPY deploy_objects.py deploy_objects.py
COPY load_datavault.py load_datavault.py
COPY film_meister_datavault_main.py film_meister_datavault_main.py
COPY ddl_scripts/ ddl_scripts/
COPY dml_scripts/ dml_scripts/
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt