# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

COPY *.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish -c Release -o /source

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /source
COPY --from=build /source ./
ENTRYPOINT ["dotnet", "TodoApi.dll"]