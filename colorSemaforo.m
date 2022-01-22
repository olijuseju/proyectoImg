
function output = colorSemaforo(nCoches,nPersonas, condicionDistancia)
    if (nCoches > nPersonas && condicionDistancia==true)
        output = true;
        
    elseif (nCoches > nPersonas && condicionDistancia==false)
        output = false;
    
    elseif (nCoches < nPersonas && condicionDistancia==true)
        output = false;
    else
        output = true;
    end
end
