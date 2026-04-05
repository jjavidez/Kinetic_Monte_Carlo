program kin_MC
    use magnitudes
    use m_ran_gen
    use m_MC_step
    use m_constants
    use m_latt_gen
    implicit none

    integer :: s(l_box**2), coord(2, l_box**2)
    integer :: step, tries, accepted_moves, rejected_moves
    integer, allocatable :: r_vector(:, :)
    real(8) :: energy, time, x_pol, y_pol
    real(8) :: phi(l_box**2)
    real(8), allocatable :: w_vector(:), r_prob(:)
    logical :: move_accepted


    !Start RNG
    call init_rng(seed)

    !Open output file
    open(unit=1, file='energy_output.txt', status='replace')
    open(unit=2, file='xpol.txt', status='replace')
    open(unit=3, file='ypol.txt', status='replace')

    !We inicialize the system and calculate the initial energy and polarization
    call lattice_gen( s , coord, phi)

    !We inicialize tower variables
    call vectors(r_vector, w_vector, r_prob)
    
    time = 0.0d0
    energy = initial_energy_calc(s, phi)
    x_pol = x_polarization(s, coord)
    y_pol = y_polarization(s, coord)

     !Write initial energy and polarization

    write(1, *) time, energy
    write(2, *) time, x_pol
    write(3, *) time, y_pol

    !Main loop for kinetic Monte Carlo steps
    tries = 0
    accepted_moves = 0
    rejected_moves = 0

    do step = 1, n_steps
        call MC_step(s, tries, coord, phi, energy, &
        accepted_moves, rejected_moves, move_accepted, &
        r_vector, r_prob)
        !print *, "Step: ", step
        if(move_accepted) then
            call MC_time(time, tries, w_vector )
            tries = 0
            x_pol = x_polarization(s, coord)
            y_pol = y_polarization(s, coord)

            !Write energy and polarization after each accepted move
            write(1, *) time, energy
            write(2, *) time, x_pol
            write(3, *) time, y_pol
        
        end if
    end do

    print *, 'accepted moves: ', accepted_moves
    print *, 'rejected moves: ', rejected_moves

    close(1)
    close(2)
    close(3)

    call close_rng()


    
end program kin_MC