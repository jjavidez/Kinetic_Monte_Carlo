module magnitudes
    use m_constants
    use m_tower
    use m_latt_gen
    implicit none
    contains


function x_polarization(s, coord) result(x_pol)
    integer, intent(in) :: s(l_box**2), coord(2, l_box**2)
    integer :: i, x_pol
    
    x_pol = 0
    do i = 1, l_box**2
        x_pol = x_pol + coord(1, i) * s(i) ! sum of x_i * s_i
    end do
end function x_polarization

function y_polarization(s, coord) result(y_pol)
    integer, intent(in) :: s(l_box**2), coord(2, l_box**2)
    integer :: i, y_pol
    
    y_pol = 0
    do i = 1, l_box**2
        y_pol = y_pol + coord(2, i) * s(i) ! sum of y_i * s_i
    end do
end function y_polarization

function random_pot(s, phi) result(rand_pot)
    integer, intent(in) :: s(l_box**2)
    real(8), intent(in) :: phi(l_box**2)
    real(8) :: rand_pot
    integer :: i
    
    rand_pot = 0.0d0
    do i = 1, l_box**2
        rand_pot = rand_pot + s(i) * phi(i) ! sum of s_i * phi_i
    end do
    
end function random_pot

function coulomb_energy ( s) result(coul_energy)
    integer, intent(in) :: s(l_box**2)
    integer :: i, j, neigh_lst(4), energy_sum, coul_energy
    
    energy_sum = 0
    do i = 1, l_box**2
        call neighbor(i, neigh_lst)
        do j = 1, 4
            energy_sum = energy_sum + s(i) * s(neigh_lst(j)) ! sum of s_i * s_j for neighbors
        end do
    end do
    
    coul_energy = energy_sum / 2 ! divide by 2 to correct for double counting
    
end function coulomb_energy


function initial_energy_calc(s, phi) result(init_energy)
    integer, intent(in) :: s(l_box**2)
    real(8), intent(in) :: phi(l_box**2)
    integer :: coul_energy, coord(2, l_box**2)
    real(8) :: rand_pot, init_energy, el_energy
    
    coul_energy = coulomb_energy(s)
    rand_pot = random_pot(s, phi)
    el_energy = el_field * real(x_polarization(s, coord), 8) ! energy from electric field
    
    init_energy = real(coul_energy, 8) + rand_pot + el_energy ! total energy
end function initial_energy_calc

function energy_change(s, dist, i, j, phi, coord) result(delta_energy)
    integer, intent(in) :: s(l_box**2), i, j, dist, coord(2, l_box**2)
    real(8), intent(in) :: phi(l_box**2)
    real(8) :: delta_energy
    integer :: neigh_lst_i(4), neigh_lst_j(4), coul_energy_change
    
    call neighbor(i, neigh_lst_i)
    call neighbor(j, neigh_lst_j)

    if (sqrt(real(((coord(1, j) - coord(1, i))**2 + (coord(2, j) - coord(2, i))**2), 8)) > 1.0d0) then
        coul_energy_change = -2 * sum(s(neigh_lst_i)) + 2 * sum(s(neigh_lst_j)) ! change in Coulomb energy from flipping s_i and s_j
    else
        coul_energy_change = -2 * sum(s(neigh_lst_i)) + 2 * sum(s(neigh_lst_j)) - 4 ! additional change from direct interaction between i and j
    end if

    !we use x distance for the electric field contribution since the field is in the x direction
    delta_energy = real(coul_energy_change, 8) + 2 * (phi(j) - phi(i)) -2 * el_field * real(dist, 8) ! total energy change from flip



    
end function energy_change

end module magnitudes
