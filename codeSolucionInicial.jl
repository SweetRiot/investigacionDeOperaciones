#-----CARGA DE DATOS DEL ARCHIVO AL PROGRAMA 
import Pkg;
Pkg.add("JSON")
using JSON;
using Random;
using DelimitedFiles;
datos = JSON.parsefile("instancia01.json")

Tiempo_procesamiento=datos["tiempo_procesamiento"]
Especialistas=datos["especialistas"]
diccionarios=datos["fecha_max_entrega"]
#-----FIN DE LA CARGA DE DATOS AL PROGRAMA-----



#-----VARIABLES GLOBALES QUE USAREMOS EN TODO EL PROYECTO
cant_especialistas=length(Especialistas)
cant_proyectos=length(diccionarios)
iteraciones=parse(Int,ARGS[1])
cantidad_de_vecinos=5
size_of_tabu=6
lista_tabu=[]
#tabu_count=0
#-----FIN DE LA DEFINICION DE VARIABLES GLOBALES-----

#-----TRATAMIENTOS DE LAS ESTRUCTURAS DE DATOS
#Pasar de diccionario a arrays
Proyectos_fecha_max=[]
for i in 1:cant_proyectos
    name_proyecto,fecha_max=first(collect(diccionarios[i]))
    push!(Proyectos_fecha_max,[name_proyecto,fecha_max])
end    

#Creo sublistas que contendrán los proyectos de cada especialista
asignacion_de_proyectos=[]
for i in 1:cant_especialistas
    push!(asignacion_de_proyectos,[])
end   

#-----FIN DEL TRATAMIENTO DE LAS ESTRUCTURAS DE DATOS-----

#-----DEFINICION DE TODAS LAS FUNCIONES

#esta funcion devuelve cuánto tiempo de procesamiento tiene todos los proyectos asignados de un especialista
function tiempo_total_especialista(proyectosAsignados)
    tiempo_total=0
    if proyectosAsignados==[]
        return 0
    else 
        for proyecto in proyectosAsignados
            tiempo_total+=proyecto[3]
        end    

    end
    return tiempo_total
end

#Esta funcion devuelve el retraso de los 20 especialistas sumado
function retraso_general(lista)
    retraso_general=0    
    for i in 1:cant_especialistas
        tiempo_absoluto=0
        retraso_por_especialista=0
        for un_proyecto_de_un_especialista in lista[i]
            tiempo_de_entrega_max=un_proyecto_de_un_especialista[2]
            tiempo_absoluto=tiempo_absoluto + un_proyecto_de_un_especialista[3]
            if tiempo_de_entrega_max < tiempo_absoluto
                retraso_por_especialista=retraso_por_especialista + tiempo_absoluto - tiempo_de_entrega_max
            end
            
        end
        retraso_general=retraso_general+retraso_por_especialista
            
    end
    return retraso_general
end  
#solo se le pasa los proyectos de un especialista y te da el retraso
function retraso_especialista(lista)
    if isempty(lista)
        return 0
    else    
        tiempo_absoluto=0
        retraso_por_especialista=0
        for un_proyecto_de_un_especialista in lista
            tiempo_de_entrega_max=un_proyecto_de_un_especialista[2]
            tiempo_absoluto=tiempo_absoluto + un_proyecto_de_un_especialista[3]
            if tiempo_de_entrega_max < tiempo_absoluto
                retraso_por_especialista=retraso_por_especialista + tiempo_absoluto - tiempo_de_entrega_max
            end 
        end
        return retraso_por_especialista
    end    
end    

#Esta función coge un proyecto de un especialista y se lo asigno a otro
function simple_move(lista_asignaciones_raw)
    #Escojo aleatoriamente un elemento como tal de mi lista_asignaciones
    lista_asignaciones=deepcopy(lista_asignaciones_raw)
    #numero_proyecto=rand(1:cant_proyectos)
    #Escojo aleatoriamente a un especialista
    n_especialista_out=rand(1:cant_especialistas)
    n_especialista_in=rand(1:cant_especialistas)
    while n_especialista_in==n_especialista_out
        n_especialista_out=rand(1:cant_especialistas)
        n_especialista_in=rand(1:cant_especialistas)
    end     
    A=length(lista_asignaciones[n_especialista_out])
    B=length(lista_asignaciones[n_especialista_in])
    while A==0
        A=length(lista_asignaciones[n_especialista_out])
    end
    while B==0    
        B=length(lista_asignaciones[n_especialista_in])
    end    
    posicion_in=rand(1:B)
    element_out=rand(1:A)
    

    insert!(lista_asignaciones[n_especialista_in],posicion_in,lista_asignaciones[n_especialista_out][element_out])
    #Escojo aleatoriamente una posición dentro de los proyectos del especialista
    deleteat!(lista_asignaciones[n_especialista_out],element_out)
    #Muevo este proyecto a cualquier parte 
    tiempo_correcto(lista_asignaciones[n_especialista_in],n_especialista_in)
    return lista_asignaciones,(lista_asignaciones[n_especialista_in][posicion_in][1], n_especialista_in)
end

#Agarra al especialista con menor retraso y a otro con mayor retraso, y toma de ellos un proyecto aleatorio y los intercambia.
#Esta funcion solo hace cambios en la lista que le pasas si encuentra una mejora, si no retorna la misma lista
function asignacion_random(lista_de_proyectos_raw)
    global tabu_count
    lista_de_proyectos=deepcopy(lista_de_proyectos_raw)
    lista_de_retrasos=[]
    for i in 1:cant_especialistas
        push!(lista_de_retrasos,retraso_especialista(lista_de_proyectos[i]))
    end
    indice_del_tardon=argmax(lista_de_retrasos)  
    indice_del_puntual=argmin(lista_de_retrasos)  

    cant_proye_tardon=length(lista_de_proyectos[indice_del_tardon])
    cant_proye_puntual=length(lista_de_proyectos[indice_del_puntual])
    
    indice_rand_tardon=rand(1:cant_proye_tardon)
    indice_rand_puntual=rand(1:cant_proye_puntual)

    aux=lista_de_proyectos[indice_del_tardon][indice_rand_tardon]
    lista_de_proyectos[indice_del_tardon][indice_rand_tardon]=lista_de_proyectos[indice_del_puntual][indice_rand_puntual]
    lista_de_proyectos[indice_del_puntual][indice_rand_puntual]=aux
    tiempo_correcto(lista_de_proyectos[indice_del_puntual],indice_del_puntual)
    tiempo_correcto(lista_de_proyectos[indice_del_tardon],indice_del_tardon)
    sort_x_fem(lista_de_proyectos)
  
    if retraso_general(lista_de_proyectos) < sum(lista_de_retrasos)
        temporal=lista_de_proyectos_raw[indice_del_tardon][indice_rand_tardon]
        lista_de_proyectos_raw[indice_del_tardon][indice_rand_tardon]=lista_de_proyectos_raw[indice_del_puntual][indice_rand_puntual]
        lista_de_proyectos_raw[indice_del_puntual][indice_rand_puntual]=temporal
        sort_x_fem(lista_de_proyectos_raw)
        return lista_de_proyectos_raw
    end

    return lista_de_proyectos_raw
end   

#Retorna los proyectos de cada especialista
function print_x_especialista(asig_proyect)
    for i in 1:cant_especialistas
        println("E",i," ",asig_proyect[i])
    end
end   

#Ordena en orden ascendente a las fechas máximas de entrega todos los proyectos
function sort_x_fem(lista_de_proyectos)
    for i in 1:cant_especialistas
        lista_de_proyectos[i]=sort(lista_de_proyectos[i], by = x->x[2])
    end
    return lista_de_proyectos
end


#esta solucion va asignando proyectos al especialista que tiene menor carga de trabajo
function primera_solucion(asig_proyect,processing_time,FEM)
    #Buena forma de hacerlo
    #Solo tenemos que reorganizarlo, las fechas de procesamiento en el orden de las fechas máximas de entrega. 
    for m in 1:cant_proyectos
        especialista_mas_nuevo_proyecto=[]
        for i in 1:20
            push!(especialista_mas_nuevo_proyecto,tiempo_total_especialista(asig_proyect[i])+processing_time[i][m])
        end
    
        indice_del_espe_asig=argmin(especialista_mas_nuevo_proyecto)
        push!(asig_proyect[indice_del_espe_asig],[FEM[m][1],FEM[m][2],processing_time[indice_del_espe_asig][m]])
        
    end 
    return asig_proyect
end 

#esta solucion va asignando proyectos al especialista que tiene menor carga de trabajo y los proyectos que
#se van asignando van en orden de su fecha máxima de entrega
function primera_solucion2(asig_proyect,processing_time,FEM)
    FEM_order=deepcopy(FEM)
    FEM_order=sort(FEM, by = x -> x[2])  
    
    for m in 1:cant_proyectos
        especialista_mas_nuevo_proyecto=[]
        #este for mete a la lista anterior, los tiempos de procesamiento que lleva cada especialista
        #se escoje al que menos tiempo tenga y se le asigna ese proyecto
        numero_del_proye = parse(Int,match(r"\d+",FEM_order[m][1]).match)
        for i in 1:20
            push!(especialista_mas_nuevo_proyecto,tiempo_total_especialista(asig_proyect[i])+processing_time[i][numero_del_proye])
        end
    
        indice_del_espe_asig=argmin(especialista_mas_nuevo_proyecto)


        push!(asig_proyect[indice_del_espe_asig],[FEM_order[m][1],FEM_order[m][2],processing_time[indice_del_espe_asig][m]])
        
    end
    
    for i in 1:20
        tiempo_correcto(asig_proyect[i],i) 
    end    
    return asig_proyect
end    

#Funcion pone los tiempos de procesamiento adecuados a cada asignacion nueva.
function tiempo_correcto(proyectos_x_especialista,numero_del_espe)
    for proyecto in proyectos_x_especialista
        numero_del_proye = parse(Int,match(r"\d+", proyecto[1]).match)
        #print("numero: ",numero_del_proye," Espe: $numero_del_espe  "," process: ")
        proyecto[3]=Tiempo_procesamiento[numero_del_espe][numero_del_proye]
    end
end

#-----FIN DE LA DEFINICION DE LAS FUNCIONES-----


#-----EJECUCION DE FUNCIONES

#Solución inicial
primera_solucion2(asignacion_de_proyectos,Tiempo_procesamiento,Proyectos_fecha_max)

solucion_actual=deepcopy(sort_x_fem(asignacion_de_proyectos))
println(retraso_general(solucion_actual))
#Fin de la solucion inicial

#TABU SEARCH
for i in 1:iteraciones
    global cantidad_de_vecinos
    global solucion_actual
    global asignacion_de_proyectos
    lista_de_vecinos=[]
    retrasos_x_vecinos=[]
    candidatos_a_entrar_en_tabu=[]
    if length(lista_tabu)==size_of_tabu
        popfirst!(lista_tabu)
    end    
    for i in 1:cantidad_de_vecinos
        lista,(proyecto,especialista)=simple_move(solucion_actual)
        if (proyecto,especialista) in lista_tabu 
            continue
        else 
            push!(lista_de_vecinos,lista)
            push!(candidatos_a_entrar_en_tabu,(proyecto,especialista))
        end
    end
    retrasos_x_vecinos=map(retraso_general,lista_de_vecinos)  

    indice_menor_retraso=argmin(retrasos_x_vecinos)
    push!(lista_tabu,candidatos_a_entrar_en_tabu[indice_menor_retraso])
    solucion_actual=lista_de_vecinos[indice_menor_retraso]
    
    if retrasos_x_vecinos[indice_menor_retraso] < retraso_general(asignacion_de_proyectos)
        asignacion_de_proyectos=deepcopy(solucion_actual)
    end

    #Periodo de intensificacion
    if i%100==0
        for i in 1:100
            asignacion_random(asignacion_de_proyectos)
        end  
    end
    #fin del periodo de intensificación

    solucion_actual=deepcopy(asignacion_de_proyectos)
end

println("Retraso de $cant_proyectos proyectos con $iteraciones iteraciones: ",retraso_general(asignacion_de_proyectos))
writedlm("resultados.csv", asignacion_de_proyectos, ',')
#EL ARCHIVO QUE CONTIENE EL RESULTADO DE LA SOLUCION SE LLAMA, resultados.csv 
#PAGAR EJECUTAR ESTE ARCHIVO TIENES QUE EJECUTARLO EN LA TERMINAL CON EL SIGUIENTE COMANDO
# julia codeSolucionInicial.jl 100000
#100000 es la cantidad de iteraciones, si deseas más o menos cambialo. 