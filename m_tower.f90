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
        integer :: i, j, n, dist_2
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
        allocate(r_vector(2, n))
        allocate(w_vector(n))
        allocate(r_prob(n))
        weight_sum = sum(w_vector(1:n))
        r_prob(1:n) = w_vector(1:n) / weight_sum
    end subroutine vectors

end module m_tower
