
getwd()
setwd("C:/Users/mpvalderrama/Desktop") #defino el directorio dnde guardar
#instalacion de librerias
library(httr)
library(jsonlite)
library(rvest)

#Mapa en tiempo real de la posicion de los aviones:
#pagina: https://openskynetwork.github.io/opensky-api/rest.html
url = "https://opensky-network.org/api/states/all"
datos <- GET(url)
#la respuesta es un formato -json... hay que convertirlo:
datos <- fromJSON(content(datos, type = "text"))
#accedemos a la columna states:
datos <- datos[["states"]]

#como vemos, no vienen los nobmres de las columnas... vamos a scrappearlas ( esto es opcional)
#extraemos datos columnas:
url = "https://openskynetwork.github.io/opensky-api/rest.html"
nombres <- read_html(url) %>% html_nodes("#all-state-vectors")  %>% html_nodes("#response")  %>% html_nodes('.docutils') %>% html_table()
#tenemos que borrar la ultima fila de nombres porque es n+1 de tamaño:
nombres <- nombres[[2]]
nombres <- nombres[-18,]  #borramos la ultima fila
colnames(datos) <- nombres$Property #ponemos las columnas nombres como cabecera de datos
datos <- as.data.frame(datos, stringsAsFactors = FALSE)


#visualizamos los datos
library(leaflet)
#comprobamos latitud y longitud y pasamos a numeric
class(datos$latitude)
class(datos$longitude)
datos$latitude <- as.numeric(datos$latitude)
datos$longitude <- as.numeric(datos$longitude)

#creamos el mapa
leaflet() %>%
  addTiles() %>%
  addCircles(lng= datos$longitude, lat= datos$latitude, color = "#FF0000" , opacity = 00.3)


      