#See https://aka.ms/customizecontainer to learn how to customize your debug container and h>

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

COPY ["Application.csproj", "./"]
RUN dotnet restore "Application.csproj"

WORKDIR "/src/Application"
COPY . .
RUN dotnet build "Application.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Application.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Install System.Drawing.Common dependency.
# RUN apt-get install -y libgdiplus

FROM mcr.microsoft.com/dotnet/core/aspnet:6.0 AS base
RUN apt-get update && apt-get install -y libgdiplus

WORKDIR /app
FROM mcr.microsoft.com/dotnet/core/sdk:6.0 AS build

# Install microsoft TrueType core fonts.
RUN apt-get install -y ttf-mscorefonts-installer

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS service
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Application.dll"]
