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
ENTRYPOINT ["dotnet", "TodoApi.dll"]

# https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly
# docker build -t todoapi .
# docker run -it --rm -p 5000:80 --name todoapi todoapi
# or
# docker run -d -p 5000:80 --name todoapi todoapi
