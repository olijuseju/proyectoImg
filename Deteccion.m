function output = Deteccion(imagenBase)


    Img = imagenBase; 
    Img = rgb2gray(Img); % Pasar a escala de grises
    
    
    vehicleDetector = vehicleDetectorACF('front-rear-view'); % Detector de vehiculos
    detectorPeople = peopleDetectorACF('inria-100x41'); % Detector de personas
    
    % Deteccion vehiculos
    [cboxes,cscores] = detect(vehicleDetector,Img);
    indice = find(cscores > 4);
    pV = cscores(indice);
    cV = cboxes(indice,:);
    Img = insertObjectAnnotation(Img,'rectangle',cV,pV);
    
    
    % Deteccion personas
    [pboxes,pscores] = detect(detectorPeople,Img);
    if not (isempty(cboxes))
        Img = insertObjectAnnotation(Img,'rectangle',pboxes,pscores);
    end
        
    numCoches = size(cboxes);
    numPersonas = size(pboxes);
    
    % Outputs
    output = [numCoches(1); numPersonas(1)];
end

