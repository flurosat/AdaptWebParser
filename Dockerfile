FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["AdaptWebParser.csproj", "adaptwebparser/"]
RUN dotnet restore "adaptwebparser/AdaptWebParser.csproj"

COPY ["." , "adaptwebparser/"]
WORKDIR "/src/adaptwebparser"
RUN dotnet build "AdaptWebParser.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "AdaptWebParser.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
COPY AdaptPlugin/ AdaptPlugin/
#RUN mkdir temp
ENTRYPOINT ["dotnet", "AdaptWebParser.dll"]