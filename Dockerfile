# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# copy everything else and build app
COPY . ./
RUN dotnet publish -c Release -o out

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /source
COPY --from=build /source/out .

COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN chmod +x /bin/docker-entrypoint.sh
ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["dotnet", "AwsCostsApi.dll"]

# https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly
# https://nickjanetakis.com/blog/a-linux-dev-environment-on-windows-with-wsl-2-docker-desktop-and-more
# docker build -t aws-costs-api .
# docker run -it --rm -p 5000:80 --name aws_costs_api aws-costs-api
# or
# docker run -d -p 5000:80 --name aws_costs_api aws-costs-api

# https://nickjanetakis.com/blog/docker-tip-56-volume-mounting-ssh-keys-into-a-docker-container
# From WSL
# docker run -d -p 8080:80 -v /c/Users/adrian.ubalde/.aws:/tmp/.aws:ro --name aws_costs_api aws-costs-api

# Debug - https://medium.com/@oprearocks/how-to-properly-override-the-entrypoint-using-docker-run-2e081e5feb9d
# docker run -it --rm -p 8080:80 -v /c/Users/adrian.ubalde/.aws:/tmp/.aws:ro --entrypoint "/bin/bash" aws-costs-api -s
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
