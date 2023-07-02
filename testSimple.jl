
# # list=[1,2,3,4]

# # changer()


# # new_list=changer(list)

# # if new_list==list
# #     print("its same")
# # end    
# # println(new_list)
# # println(list)

# # function changer(lista_raw)
# #     lista=lista_raw[:]
# #     lista[1]=1999
# # return lista    
# # end

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

dic=[Dict("P001" => 490), Dict("P002" => 202), Dict("P003" => 136)]
Proyectos=[]
for i in 1:3 
    arreglo,reg=first(collect(dic[i]))
    println(arreglo)
    push!(Proyectos,[arreglo,reg])
end  

print(Proyectos)