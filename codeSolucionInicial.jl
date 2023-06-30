#Carga de datos de nuestro archivo a nuestro programa
import Pkg;
Pkg.add("JSON")
using JSON;
datos = JSON.parsefile("instancia01.json")


#separamos nuestros datos en 3 listas generales que tenemos en instancia01.json
Tiempo_procesamiento=datos["tiempo_procesamiento"]
Especialistas=datos["especialistas"]

#Pasar de diccionario a pares ordenados
diccionarios=datos["fecha_max_entrega"]
Proyectos_fecha_max=[]
for i in 1:200
    (name_proyecto,fecha_max)=first(collect(diccionarios[i]))
    push!(Proyectos_fecha_max,(name_proyecto,fecha_max))
    #println(Proyectos_fecha_max[i])
end    
#Proyectos_fecha_max es la lista que obtenemos de pasar 
#los diccionarios {"P001"=>490} a pares ordenados ("POO1",490)

#creo una lista que contiene 20 listas
#La lista 1 contiene los proyectos del E01, así hasta la lista 20 
asignacion_de_proyectos=[]
for i in 1:20
    push!(asignacion_de_proyectos,[])
end    


function tiempo_total_especialista(proyectosAsignados)
    tiempototal=0
    if proyectosAsignados==[]
        return 0
    else 
        for proyecto in proyectosAsignados
            tiempototal=tiempototal+proyecto[3]
        end    

    end
    return tiempototal
end

#ASIGNACION DE PROYECTOS
for m in 1:200
    especialista_mas_nuevo_proyecto=[]
    for i in 1:20
        push!(especialista_mas_nuevo_proyecto,tiempo_total_especialista(asignacion_de_proyectos[i])+Tiempo_procesamiento[i][m])
    end

    indice_del_especialista_asig=argmin(especialista_mas_nuevo_proyecto)
    push!(asignacion_de_proyectos[indice_del_especialista_asig],(Proyectos_fecha_max[m][1],Proyectos_fecha_max[m][2],Tiempo_procesamiento[indice_del_especialista_asig][m]))
    
end    


function cuanto_de_retraso_tiene(lista)
    retraso_general=0    
    for i in 1:20
        tiempo_absoluto=0
        retraso_por_especialista=0
        for un_proyecto_de_un_especialista in lista[i]
            tiempo_de_entrega_max=un_proyecto_de_un_especialista[2]
            tiempo_absoluto=tiempo_absoluto + un_proyecto_de_un_especialista[3]
            #println(tiempo_de_entrega_max," ",tiempo_absoluto)
            if tiempo_de_entrega_max < tiempo_absoluto
                #println(tiempo_de_entrega_max," ",tiempo_absoluto)
                retraso_por_especialista=retraso_por_especialista + tiempo_absoluto - tiempo_de_entrega_max
            end
            
        end
        retraso_general=retraso_general+retraso_por_especialista
            
    end
    return retraso_general
end    



for i in 1:20
    asignacion_de_proyectos[i]=sort(asignacion_de_proyectos[i], by = x->x[2])
    println(asignacion_de_proyectos[i])
end

println("El tiempo de retraso en los 200 proyectos es: ",cuanto_de_retraso_tiene(asignacion_de_proyectos))


#CODIGO DE INTERCAMBIO DEL PROYECTO

# for i in 1:17
#     global copia
#     copia=generator(copia)
# end    

# println(generator(copia))
# println(generator(generator(copia)))
# println(generator(generator(generator(copia))))


# function generator(lista_de_proyectos_raw)
#     lista_de_proyectos=lista_de_proyectos_raw[:]
    
#     tiempos_de_procesamiento_x_especialista=[]

#     for i in 1:20
#         push!(tiempos_de_procesamiento_x_especialista,tiempo_total_especialista(lista_de_proyectos[i]))    
#     end

#     mayor=argmax(tiempos_de_procesamiento_x_especialista)
#     menor=argmin(tiempos_de_procesamiento_x_especialista)
#     println("LISTA:", tiempos_de_procesamiento_x_especialista)

    
#     auxiliar=lista_de_proyectos[mayor][3] #primer pryecto del que tiene más
#     lista_de_proyectos[mayor][3]=lista_de_proyectos[menor][1] #primer proyecto del que tiene menos
#     lista_de_proyectos[menor][1]=auxiliar
#     return lista_de_proyectos
# end    


# newlist=generator(asignacion_de_proyectos)
# if newlist==asignacion_de_proyectos
#     println("Same")
# end 
# lista1=generator(copia)
# lista2=generator(lista1)
# lista3=generator(lista2)
# generator(generator(generator(lista3)))


