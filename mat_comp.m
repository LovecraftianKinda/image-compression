function ReturnMatrix = mat_comp(matrix,k)

    matrix = double(matrix);
    [U S V] = svd(matrix,'econ') ; %calculating U S V values

    %k_max to cap the max value k can be
    k_max = min(size(matrix));

    %S is always non-negative as they are the roots of eigenvalues of AA'
    %Matlab and OCTAVE always present these in descending order
    %so to compress stuff we don't need to sort for the most significant
    U_k = U(:,1:k);
    S_k = S(1:k,1:k);
    V_k = V(:, 1:k);
    %now performing the matrix multiplication(rank k approximation)
    ReturnMatrix = U_k * (S_k * V_k');
    %we have to clamp values between 255 and 0
    ReturnMatrix = min(ReturnMatrix,255);
    ReturnMatrix = max(ReturnMatrix,0);

    %converting back to uint8 as the standard image format
    ReturnMatrix  = uint8(ReturnMatrix);
end
