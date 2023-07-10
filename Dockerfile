FROM python:3.9.2-alpine

# workdir
WORKDIR /usr/src/app

# copy all the files to the container
COPY . .

# venv
ENV VIRTUAL_ENV=/usr/src/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# upgrade pip & install requirements & initdb & admin
RUN pip install -i https://pypi.douban.com/simple/ --upgrade pip --no-cache-dir \
    && python -m venv $VIRTUAL_ENV \
    && pip install -i https://pypi.douban.com/simple/ -r requirements.txt --no-cache-dir \
    && flask initdb \
    && flask admin --username=admin --password=admin

EXPOSE 5000

CMD ["gunicorn", "--workers=2", "--bind=0.0.0.0:5000", "wsgi:app"]