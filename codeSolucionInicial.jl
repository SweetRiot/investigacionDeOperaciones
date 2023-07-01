#Carga de datos de nuestro archivo a nuestro programa
import Pkg;
Pkg.add("JSON")
using JSON;
using Random;
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
    #puedo tener otro argumento en esta funcion para que me muestre el retraso por especialista
    retraso_general=0    
    for i in 1:20
        tiempo_absoluto=0
        retraso_por_especialista=0
        for un_proyecto_de_un_especialista in lista[i]
            tiempo_de_entrega_max=un_proyecto_de_un_especialista[2]
            tiempo_absoluto=tiempo_absoluto + un_proyecto_de_un_especialista[3]
            #println(tiempo_de_entrega_max," ",tiempo_absoluto)
            if tiempo_de_entrega_max < tiempo_absoluto
                retraso_por_especialista=retraso_por_especialista + tiempo_absoluto - tiempo_de_entrega_max
            end
            
        end
        #println("RETRASO POR ESPECIALISTA ",i," ",retraso_por_especialista)
        retraso_general=retraso_general+retraso_por_especialista
            
    end
    return retraso_general
end    


#Algoritmo que ordena en orden ascendente las FEM
for i in 1:20
    asignacion_de_proyectos[i]=sort(asignacion_de_proyectos[i], by = x->x[2])
    #println("ESPECIALISTA: ",i," ",asignacion_de_proyectos[i])
end

println("El tiempo de retraso en los 200 proyectos es: ",cuanto_de_retraso_tiene(asignacion_de_proyectos))


#hago un swap agarrando proyectos random, compruebo si se reduce el retraso de la suma de los dos especialistas, si sí, se queda, si no, vuelve a la original. 
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
    #esta funcion está asignando sin que siquiera entre al IF
    #compruebo quien es el más puntual y quién es el más demorón
    lista_de_retrasos=[]
    for i in 1:20
        push!(lista_de_retrasos,retraso_especialista(lista_de_proyectos[i]))
    end
    indice_del_tardon=argmax(lista_de_retrasos)  
    indice_del_puntual=argmin(lista_de_retrasos)  

    cant_proye_tardon=length(lista_de_proyectos[indice_del_tardon])
    cant_proye_puntual=length(lista_de_proyectos[indice_del_puntual])
    
    indice_rand_tardon=rand(1:cant_proye_tardon)
    indice_rand_puntual=rand(1:cant_proye_puntual)


    #hacer el swap de proyectos
    # proyectos_tardon=lista_de_proyectos[indice_del_tardon]
    # proyectos_puntual=lista_de_proyectos[indice_del_puntual]

    aux=lista_de_proyectos[indice_del_tardon][indice_rand_tardon]
    lista_de_proyectos[indice_del_tardon][indice_rand_tardon]=lista_de_proyectos[indice_del_puntual][indice_rand_puntual]
    lista_de_proyectos[indice_del_puntual][indice_rand_puntual]=aux

    ##nuevo_retraso=retraso_especialista(proyectos_puntual)+retraso_especialista(proyectos_tardon)
    ##original_retraso=retraso_especialista(lista_test[indice_del_tardon])+retraso_especialista(lista_test[indice_del_puntual])
    
    #original_retraso=lista_de_retrasos[indice_del_tardon]+lista_de_retrasos[indice_del_puntual]
    #ver que mi funcion de retraso x exx funque  
    #sin entrar al if ya se están generando otras asignaciones VEEEEER
    nuevo_retraso=cuanto_de_retraso_tiene(lista_de_proyectos)
    original_retraso=sum(lista_de_retrasos)
    if nuevo_retraso < original_retraso
        #Está habiendo asignacion aún así no cumpla esta condicion, en cada iteracion estoy haciendo una asignacion. 
        #usando otras variables, como hace rato haz la comparacion
        #recien dentro del if haz la asignacion. 
        temporal=lista_de_proyectos_raw[indice_del_tardon][indice_rand_tardon]
        lista_de_proyectos_raw[indice_del_tardon][indice_rand_tardon]=lista_de_proyectos_raw[indice_del_puntual][indice_rand_puntual]
        lista_de_proyectos_raw[indice_del_puntual][indice_rand_puntual]=temporal
        #No estarán mal mis asignaciones ?
        
        # println("Nueva asignacion ","nuevo: ",nuevo_retraso," original: ",original_retraso)
        # println("Lista del puntual: ", lista_de_proyectos[indice_del_puntual])
        # println("PROYECTO ASIG AL PUNT: ",temporal)
        # println("Lista del tardon: ",lista_de_proyectos[indice_del_tardon])
        # println("PROYECTO ASIG AL TARD: ",lista_de_proyectos[indice_del_tardon][indice_rand_tardon] )
    end
    return lista_de_proyectos_raw
end    


# for i in 1:20
#     println(asignacion_de_proyectos[i])
# end    

for i in 1:1000000
    random_swap_asig_verif(asignacion_de_proyectos)
end 

for i in 1:20
    asignacion_de_proyectos[i]=sort(asignacion_de_proyectos[i], by = x->x[2])
    #println("ESPECIALISTA: ",i," ",asignacion_de_proyectos[i])
end

println("luego de iterar: ",asignacion_de_proyectos)
println("PI: ",cuanto_de_retraso_tiene(asignacion_de_proyectos))

# new1=random_swap_asig_verif(asignacion_de_proyectos)
#println(cuanto_de_retraso_tiene(new1))

# new2=random_swap_asig_verif(new1)
# println(cuanto_de_retraso_tiene(new2))

# new3=random_swap_asig_verif(new2)
# println(cuanto_de_retraso_tiene(new3))

# new4=random_swap_asig_verif(new3)
# println(cuanto_de_retraso_tiene(new4))

# for i in 1:20
#     println(retraso_especialista(newnew[i]))
# end    

# copia=asignacion_de_proyectos[:]
# for i in 1:100
#     global copia
#     copia=random_swap_asig_verif(copia)
# end    

# println("LUEGO DE 7 ITERACIONES EL RETRASO ES ",cuanto_de_retraso_tiene(copia))

# for i in 1:20
#     println(copia[i])
# end    
