#-----CARGA DE DATOS DEL ARCHIVO AL PROGRAMA 
import Pkg;
Pkg.add("JSON")
using JSON;
using Random;
datos = JSON.parsefile("instancia01.json")

Tiempo_procesamiento=datos["tiempo_procesamiento"]
Especialistas=datos["especialistas"]
diccionarios=datos["fecha_max_entrega"]
#-----FIN DE LA CARGA DE DATOS AL PROGRAMA-----



#-----VARIABLES GLOBALES QUE USAREMOS EN TODO EL PROYECTO
cant_especialistas=length(Especialistas)
cant_proyectos=length(diccionarios)
iteraciones=parse(Int,ARGS[1])
#-----FIN DE LA DEFINICION DE VARIABLES GLOBALES-----

#-----TRATAMIENTOS DE LAS ESTRUCTURAS DE DATOS
#Pasar de diccionario a pares ordenados
Proyectos_fecha_max=[]
for i in 1:cant_proyectos
    (name_proyecto,fecha_max)=first(collect(diccionarios[i]))
    push!(Proyectos_fecha_max,(name_proyecto,fecha_max))
end    

#Creo sublistas que contendrán los proyectos de cada especialista
asignacion_de_proyectos=[]
for i in 1:cant_especialistas
    push!(asignacion_de_proyectos,[])
end   

#-----FIN DEL TRATAMIENTO DE LAS ESTRUCTURAS DE DATOS-----

#-----DEFINICION DE TODAS LAS FUNCIONES
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

function random_swap_asig_verif(lista_de_proyectos_raw)
    lista_de_proyectos=lista_de_proyectos_raw[:]
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

    nuevo_retraso=retraso_general(lista_de_proyectos)
    original_retraso=sum(lista_de_retrasos)
    if nuevo_retraso < original_retraso
        temporal=lista_de_proyectos_raw[indice_del_tardon][indice_rand_tardon]
        lista_de_proyectos_raw[indice_del_tardon][indice_rand_tardon]=lista_de_proyectos_raw[indice_del_puntual][indice_rand_puntual]
        lista_de_proyectos_raw[indice_del_puntual][indice_rand_puntual]=temporal
    end
    return lista_de_proyectos_raw
end   

function print_x_especialista(asig_proyect)
    for i in 1:cant_especialistas
        println("E",i," ",asig_proyect[i])
    end
end   

function sort_x_fem(lista_de_proyectos)
    for i in 1:cant_especialistas
        lista_de_proyectos[i]=sort(lista_de_proyectos[i], by = x->x[2])
    end
    return lista_de_proyectos
end

function primera_solucion(asig_proyect,processing_time,FEM)
    for m in 1:cant_proyectos
        especialista_mas_nuevo_proyecto=[]
        for i in 1:20
            push!(especialista_mas_nuevo_proyecto,tiempo_total_especialista(asig_proyect[i])+processing_time[i][m])
        end
    
        indice_del_espe_asig=argmin(especialista_mas_nuevo_proyecto)
        push!(asig_proyect[indice_del_espe_asig],(FEM[m][1],FEM[m][2],processing_time[indice_del_espe_asig][m]))
        
    end 
    return asig_proyect
end 
#-----FIN DE LA DEFINICION DE LAS FUNCIONES-----


#-----EJECUCION DE FUNCIONES

primera_solucion(asignacion_de_proyectos,Tiempo_procesamiento,Proyectos_fecha_max)
sort_x_fem(asignacion_de_proyectos)
for i in 1:iteraciones
    random_swap_asig_verif(asignacion_de_proyectos)
    sort_x_fem(asignacion_de_proyectos)
end 

println("Retraso de $cant_proyectos proyectos con $iteraciones iteraciones: ",retraso_general(asignacion_de_proyectos))