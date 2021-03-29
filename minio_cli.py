from django.core.files.base import ContentFile
from minio import Minio
import enum
from os import getenv
import logging

logging.basicConfig(filename='app.log', filemode='w', format='%(asctime)s - %(levelname)s:%(message)s')
MINIO_ENDPOINT = getenv('MINIO_ENDPOINT')
MINIO_ACCESS_KEY = getenv('MINIO_ACCESS_KEY')
MINIO_SECRET_KEY = getenv('MINIO_SECRET_KEY')

client = Minio(
    MINIO_ENDPOINT,
    access_key=MINIO_ACCESS_KEY,
    secret_key=MINIO_SECRET_KEY,
    secure=False
)


class BucketName(enum.Enum):
    Code = getenv('MINIO_BUCKET_CODE')
    Map = getenv('MINIO_BUCKET_MAP')
    Log = getenv('MINIO_BUCKET_LOG')


for e in BucketName:
    found = client.bucket_exists(e.value)
    if not found:
        client.make_bucket(e.value)


class MinioClient:

    @staticmethod
    def upload_logs(path, file, file_name) -> bool:  # todo change
        content = ContentFile(file.read())
        bucket_name = BucketName.Log.value
        try:
            client.put_object(
                bucket_name, f'{path}/{file_name}.zip', content, length=len(content)
            )
            return True
        except Exception as e:
            logging.warning(e)
            return False

    @staticmethod
    def get_compiled_code(file_id):
        try:
            response = client.get_object(BucketName.Code.value, f'compiled/{file_id}.zip')
            return response.data
        except:
            return None

    @staticmethod
    def get_map(map_id):
        try:
            response = client.get_object(BucketName.Map.value, f'{map_id}.zip')
            return response.data
        except:
            return None
