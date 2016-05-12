require 'chilkat'
require 'rubygems'
require 'nokogiri'   
require 'open-uri'
require 'active_support/inflector'
require 'map'

spider = Chilkat::CkSpider.new()


spider.Initialize("www.metrolyrics.com")

#Se agrega primera pagina a analizar por la araña
spider.AddUnspidered("http://www.metrolyrics.com/")

#Se abre documento donde se guardara el numero de documento, URL y letra de 
#cancion para ser normalizada, parseada y tokenizada.
output = File.open( "outputfile.txt","w" )


#Por motivos de poder computacional se analiza un conjunto acotado de paginas web 
#aunque se pretende que eventualmente podria ser escalable al valor deseado
#

mapa = Map.new()

i=0
while (i<3)
    
    #Se analiza la siguiente URL en la lista de paginas
    success = spider.CrawlNext()
    if (success == true)
        #este if verificara que la url tenga el patron de las paginas con letra de canciones
        if(
            #el patron es nombre pag/nombrecancion-lyrics-autor.html
            (/(.*)-lyrics-(.*)/ =~ spider.lastUrl())&& 
            # (/(.*)(html$)/ =~ spider.lastUrl())&& #Este creo q va comentado porque creo q no importa que terminen en html.*
            #debe evitar los casos de abajop porque parecen cumplir el criterio pero no son paginas de letras de canciones.
            (/(.*)(discussions)(.*)/ !~ spider.lastUrl())&&
            (/(.*)(news-story)(.*)/ !~ spider.lastUrl())&&
            (/(.*)(news-gallery)(.*)/ !~ spider.lastUrl())&&
            (/(.*)(printlyric)(.*)/ !~ spider.lastUrl())
            )
            #  Show the URL of the page just spidered.
            i=i+1
        
            # Se salva numero de documento, URL y letra de cancion encontrada
            output << i
            output <<  "\n"
            output << spider.lastUrl() + "\n";
            lyric = Nokogiri::HTML(spider.lastHtml()).css("div#lyrics-body-text p.verse").map {|div| div.content}
            # print 
            
            
            #Todas las mayusculas a minusculas
            downcasiado = (String(lyric)).downcase
            
            #Como viene del casteado arreglamos el hecho de que "\n" viene como 2 caracteres en vez de uno
            arregleEspacios = downcasiado.gsub('\n',"\n")
            
            #Quitamos underscores del todo
            sinUnderscore = arregleEspacios.gsub("_","")
            
            #Cambia espacios por '_' para que no se cambien cuando usemos el \W
            espaciosPorUnderscore1 = sinUnderscore.gsub(" ","_")
            espaciosPorUnderscore = espaciosPorUnderscore1.gsub("\n","_")
            #aqui dejamos solo letras numeros y _(espacios)
            stringSinSimbolos = espaciosPorUnderscore.gsub(/\W/,'')
            #devolv
            # soloFaltaDeSplitear= stringSinSimbolos.gsub("_"," ") #Commentado porque al momento del split se le dice que divida por _
            
            tokenizado = stringSinSimbolos.split("_")
            mapa.map{|i| tokenizado}
            
            
            output << tokenizado
            output << "\n\n"
            print mapa
            
            
            
            
            
            
            
            #  print (((((String(lyric)).downcase).gsub('\n',"\n")).gsub!(/\W | ' '/,'')).split(" "))
            
            # print lyric[0].downcase
            # output << lyric[0].downcase
            #  output << (lyric.join("\n") + "\n\n")
            
          
            
            
            # Obtenemos pagina
            # Escribimos numero de documento
            # Escribimos url a como viene
            # Obtenemos letra de cancion(conjunto de caracteres)(lyrics)
            
            # split(lyrics( " " && "\n"))->Array          Normalize todo lyrics
            # Recorrer array analizando mediate regex     Haga split
            
            
            # Tokenizamos (haciendo un split por espacios)()
            # Normalizamos
            
            # Guardarlo en output
            
            
            # Escribimos 
            
            
            
            
            
            
            
        end
    #  The HTML is available in the LastHtml property
    else
        #  Did we get an error or are there no more URLs to crawl?
        if (spider.get_NumUnspidered() == 0)
            print "No more URLs to spider" + "\n";
        else
            print spider.lastErrorText() + "\n";
        end

    end

    #  Sleep 1 second before spidering the next URL.
    spider.SleepMs(1)
end

    # print ((('asd ASD! ASasdD'.downcase).split(" ")).gsub!(/\W/,''))
output.close
