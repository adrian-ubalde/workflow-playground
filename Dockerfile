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

# https://nickjanetakis.com/blog/docker-tip-56-volume-mounting-ssh-keys-into-a-docker-container
# From WSL
# docker run -d -p 8080:80 -v /c/Users/adrian.ubalde/.aws:/tmp/.aws:ro --name todoapi todoapi

# https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly
# docker build -t todoapi .
# docker run -it --rm -p 5000:80 --name todoapi todoapi
# or
# docker run -d -p 5000:80 --name todoapi todoapi
