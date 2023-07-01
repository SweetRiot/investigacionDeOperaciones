
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

lista=[1,2,3,4,5,6]

function change(lista)
    newlista=lista[:]
    newlista[1]=1000
    return newlista
end    

new=change(lista)

println(lista)
