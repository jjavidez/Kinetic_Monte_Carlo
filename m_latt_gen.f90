module m_latt_gen
    use m_constants
    use m_ran_gen
    implicit none
contains

subroutine lattice_gen( s , coord, phi)
    integer, intent(out):: s(l_box**2), coord(2, l_box**2)
    real(8), intent(out) :: phi(l_box**2)
    integer :: i, j, k, n, random_list((l_box**2)/2)
    n = 0
    call choose_half_random(l_box ** 2, random_list)
    do i = 1, l_box
        do j = 1, l_box
            n = n + 1
            if (all(random_list /= n)) then
                s(n) = -1
            else
                s(n) = 1
            end if
            coord(1, n) = i
            coord(2, n) = j
            phi(n) = get_random() * 2.0d0 - 1.0d0 !random potential between -1 and 1
        end do
    end do
end subroutine lattice_gen

subroutine neighbor (s, index, neigh_lst)
    integer, intent(in) :: s(l_box**2), index
    integer, intent(out) :: neigh_lst(4) !left, right, up, down
    integer, intent(out) :: neight_sum
    
   if (mod(index -1 , l_box) == 0) then
        neigh_lst(1) = index + l_box - 1 ! left
    else
        neigh_lst(1) = index - 1 ! left
    end if
    
    if (mod(index, l_box) == 0) then
        neigh_lst(2) = index - l_box + 1 ! right
    else
        neigh_lst(2) = index + 1 ! right
    end if
    
    neigh_lst(3) = index - l_box ! up
    if (neigh_lst(3) < 1) then
        neigh_lst(3) = neigh_lst(3) + l_box**2 ! wrap around up
    end if

    neigh_lst(4) = index + l_box ! down
    if (neigh_lst(4) > l_box**2) then
        neigh_lst(4) = neigh_lst(4) - l_box**2 ! wrap around down
    end if
    
end subroutine neighbor

end module m_latt_gen