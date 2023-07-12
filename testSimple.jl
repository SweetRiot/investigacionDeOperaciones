
# list=[-2,-203,-33,-4]
# deleteat!(list,3)
# println(list)

# function Hola()
#     return 34,(70,80)
# end
# a,(b,c)=Hola()
# println(a)
# println(b)
# println(c)

# lista = [("a", 45), ("b", 32), ("d", 11), ("e", 33)]

# # Utilizar sort con una función anónima para ordenar la lista por el segundo elemento de cada tupla
# lista_ordenada = sort(lista, by = x -> x[2])

# # Imprimir la lista ordenada
# println(lista_ordenada)
# using Random; 

# lista=[[1,2,3],2,3,4,5,6]

# function change(lista)
#     newlista=lista[:]
#     lista[3]=1000
#     return lista
# end    



# change(lista[1])
# println(lista)
# numero = parse(Int,match(r"\d+", "P200").match)
# println(numero)
# println(typeof(numero))

# dic=[Dict("P001" => 490), Dict("P002" => 202), Dict("P003" => 136)]
# Proyectos=[]
# for i in 1:3 
#     arreglo,reg=first(collect(dic[i]))
#     println(arreglo)
#     push!(Proyectos,[arreglo,reg])
# end  

# print(Proyectos)

# for i in 1:10
#     if i == 5
#         println("SALIENDO")
#         continue  # Salta la iteración cuando i es igual a 5
#     end
#     println(i)
# end
lista=Set([1,2,3,4,5,6])
# for i in lista
#     println(i)
# end    
# println(argmin(lista))
# M=Missing
# function suma(a)
#     return a+1
# end   
# suma(M)
lista2=Set([6,5,4,3,2,1,67])

@time if isequal(lista,lista2)
    print("SON IGUALES")
else 
    println("NO SON IGUALES")    
end    