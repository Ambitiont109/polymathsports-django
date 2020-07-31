from polymath.celery import app

@app.task
def monitoring():
    print('***** Monitoring Polymath *********')
