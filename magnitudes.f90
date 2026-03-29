module magnitudes
    use m_constants
    use m_tower
    use m_latt_gen
    implicit none
    contains


function x_polarization(s, coord) result(x_pol)
    integer, intent(in) :: s(l_box**2), coord(2, l_box**2)
    integer, intent(out) :: x_pol
    integer :: i
    
    x_pol = 0
    do i = 1, l_box**2
            x_pol = x_pol + coord(1, i) * s(i) ! sum of x_i * s_i
        end if
    end do
    
end function x_polarization

function y_polarization(s, coord) result(y_pol)
    integer, intent(in) :: s(l_box**2), coord(2, l_box**2)
    integer, intent(out) :: y_pol
    integer :: i
    
    y_pol = 0
    do i = 1, l_box**2
            y_pol = y_pol + coord(2, i) * s(i) ! sum of y_i * s_i
        end if
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
        end if
    end do
    
end function random_pot

function coulomb_energy ( s), result(coul_energy)
    integer, intent(in) :: s(l_box**2)
    integer :: i, j, neigh_lst(4), energy_sum, coul_energy
    
    energy_sum = 0
    do i = 1, l_box**2
        call neighbor(s, i, neigh_lst)
        do j = 1, 4
            energy_sum = energy_sum + s(i) * s(neigh_lst(j)) ! sum of s_i * s_j for neighbors
        end do
    end do
    
    coul_energy = energy_sum / 2.0d0 ! divide by 2 to correct for double counting
    
end function coulomb_energy


function initial_energy_calc(s, phi) result(init_energy)
    integer, intent(in) :: s(l_box**2)
    real(8), intent(in) :: phi(l_box**2)
    integer :: coul_energy
    real(8) :: rand_pot, init_energy
    
    coul_energy = coulomb_energy(s)
    rand_pot = random_pot(s, phi)
    el_energy = el_field * x_polarization(s, coord) ! energy from electric field
    
    init_energy = coul_energy + rand_pot + el_energy ! total energy
    
end function initial_energy_calc

function energy_change(s, dist, i, j, phi) result(delta_energy)
    integer, intent(in) :: s(l_box**2), i, j
    real(8), intent(in) :: phi(l_box**2), dist
    real(8) :: el_energy_change, rand_pot_change, delta_energy
    integer :: neigh_lst(4), coul_energy_change
    
    call neighbor(s, i, neigh_lst_i)
    call neighbor(s, j, neigh_lst_j)

    if (dist > 1.0d0) then
        coul_energy_change = -2 * sum(s(neigh_lst_i)) + 2 * sum(s(neigh_lst_j)) ! change in Coulomb energy from flipping s_i and s_j
    else
        coul_energy_change = -2 * sum(s(neigh_lst_i)) + 2 * sum(s(neigh_lst_j)) - 4 ! additional change from direct interaction between i and j
    end if

    delta_energy = coul_energy_change + 2 * (phi(j) - phi(i)) -2 * el_field * (coord(1, j) - coord(1, i)) ! total energy change from flip



    
end function energy_change

