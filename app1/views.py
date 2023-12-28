from django.shortcuts import render

def index(request):
    message = "Happy Dockerizing!!"
    return render(request, 'index.html', {"message": message})
