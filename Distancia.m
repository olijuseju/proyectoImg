
function output = Distancia(imagenBase)
    img= imagenBase; 
    vehicleDetector = vehicleDetectorACF('front-rear-view'); % Cargamos el detector de vehiculos
    peopleDetector = peopleDetectorACF('inria-100x41'); % Cargamos el detector de personas
    
    % Deteccion vehiculos
    [cboxes,cscore] = detect(vehicleDetector,img);
    i = find(cscore >4);

    pV = cscore(i);
    cV = cboxes(i,:);
    
    img = insertObjectAnnotation(img,'rectangle',cV,pV);
        
    % Deteccion personas
    [cajasPersonas,puntuacionPersonas] = detect(peopleDetector,img);
    if not (isempty(cajasPersonas))
        img= insertObjectAnnotation(img,'rectangle',cajasPersonas,puntuacionPersonas);
    end
    img= rgb2gray(img);
    img= imbinarize(img, 'adaptive','Sensitivity',0.4);
    img= imfill(img,'holes');
    SE = strel('rectangle',[5,4]);
    img= imdilate(img,SE);
    BW = edge(img);

    %CALCULO DE DISTANCIAS
    [H,T,R] = hough(BW,'RhoResolution',0.5,'Theta',-90:0.5:89);
    P = houghpeaks(H, 5, 'threshold', ceil(0.3*max(H(:))));
    x = T(P(:,2));
    y = R(P(:,1));
    lines = houghlines(BW, T, R, P, 'FillGap', 5, 'MinLength', 7);

%     figure
%     imshow(BW), hold on

    max_len = 0;
    distanciaCoche = 10000000;
    distanciaPersona = 10000000;
    
    for k = 1: length(lines)
        xy = [lines(k).point1; lines(k).point2];
%         plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');
%         plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 2, 'Color', 'yellow');
%         plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 2, 'Color', 'red');
        len = norm(lines(k).point1 - lines(k).point2);
        if (len > max_len)
         max_len = len;
        end
        
        for j = 1: length(cV)
            d = sqrt( (cV(2,j) - cV(1,j)).^2 + (lines(k).point2 - lines(k).point1).^2);
            if (d < distanciaCoche)
                distanciaCoche = d;
            end
        end
        
        for l = 1: length(cajasPersonas)
            di = sqrt( (cajasPersonas(2,l) - cajasPersonas(1,l)).^2 + (lines(k).point2 - lines(k).point1).^2);
            if (di < distanciaPersona)
                distanciaPersona = di;
            end
        end
    end
    
    % Outputs
    if (distanciaCoche >= distanciaPersona)
        output = true;
    else
        output = false;
    end
    
end