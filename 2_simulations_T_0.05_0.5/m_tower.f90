module m_tower
    use m_constants
    use m_latt_gen
    implicit none
    contains


    subroutine vectors (r_vector, w_vector, r_prob)
        integer, intent(out), allocatable :: r_vector(:, :) ! relative position vectors to the first site
        real(8), intent(out), allocatable :: w_vector(:) ! weights for each vector
        real(8), intent(out), allocatable :: r_prob(:) ! probabilities for each vector
        real(8) :: weight_sum
        integer :: i, j, k, n, dist_2, n_vectors
        n = 0
        
        !First, we count how many vectors are within the cut-off distance to allocate the arrays
        n_vectors = 0

         do i = -l_box/2, l_box/2 
            do j = -l_box/2, l_box/2
                if (i == 0 .and. j == 0) cycle

                dist_2 = i**2 + j**2

                if (dist_2 < cut_off **2) then
                    n_vectors = n_vectors + 1
                end if
            end do
        end do

        allocate(r_vector(2, n_vectors))
        allocate(w_vector(n_vectors))
        allocate(r_prob(n_vectors))


        !Then we fill the arrays with the vectors and their corresponding weights and probabilities
         n = 0
        do i = -l_box/2, l_box/2 
            do j = -l_box/2, l_box/2
                if (i == 0 .and. j == 0) cycle

                dist_2 = i**2 + j**2

                if (dist_2 < cut_off **2) then
                    n = n + 1
                    r_vector(1, n) = i
                    r_vector(2, n) = j
                    w_vector(n) = exp(-2 * sqrt(real(dist_2, 8)))
                end if
            end do
        end do

        weight_sum = sum(w_vector(1:n))
        do k = 1, n
            r_prob(k) = sum(w_vector(1:k)) / weight_sum
        end do
        print *, "Tower variables initialized."
        
    end subroutine vectors


     function tower_sample(tower) result(sample)
        real(8), intent(in) :: tower(:)
        integer :: sample, inf, sup, center
        real(8) :: rand_val

        rand_val = get_random()
        inf = 1
        sup = size(tower)

        if (rand_val < tower(1)) then
            sample = 1
            return
        end if

        do while (inf <= sup)
            center = (inf + sup) / 2
            if (rand_val > tower(center)) then
                inf = center + 1
            else
                sup = center - 1
                sample = center
            end if
        end do
    end function tower_sample

end module m_tower
