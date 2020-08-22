# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# copy everything else and build app
COPY . ./
RUN dotnet publish -c Release -o out

# final stage/image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /source
COPY --from=build /source/out .
# ENTRYPOINT ["dotnet", "TodoApi.dll"]

COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN chmod +x /bin/docker-entrypoint.sh
ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["dotnet", "TodoApi.dll"]

# https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly
# https://nickjanetakis.com/blog/a-linux-dev-environment-on-windows-with-wsl-2-docker-desktop-and-more
# docker build -t todoapi .
# docker run -it --rm -p 5000:80 --name todoapi todoapi
# or
# docker run -d -p 5000:80 --name todoapi todoapi

# https://nickjanetakis.com/blog/docker-tip-56-volume-mounting-ssh-keys-into-a-docker-container
# From WSL
# docker run -d -p 8080:80 -v /c/Users/adrian.ubalde/.aws:/tmp/.aws:ro --name todoapi todoapi

# Debug - https://medium.com/@oprearocks/how-to-properly-override-the-entrypoint-using-docker-run-2e081e5feb9d
# docker run -it --rm -p 8080:80 -v /c/Users/adrian.ubalde/.aws:/tmp/.aws:ro --entrypoint "/bin/bash" todoapi -s
# How do trouble-shoot a problem where AWS Fargate task cannot launch a container from your image?
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/troubleshooting.html
# docker 
# logs        Fetch the logs of a container
# history  Show the history of an image

# Run Graphical Applications from WSL
# https://sourceforge.net/projects/vcxsrv/
# https://stackoverflow.com/questions/61110603/how-to-set-up-working-x11-forwarding-on-wsl2
# https://seanthegeek.net/234/graphical-linux-applications-bash-ubuntu-windows/#:~:text=Install%20VcXsrv&text=VcXsrv%20is%20the%20only%20fully,Accept%20the%20default%20options.

# https://www.katacoda.com/learn