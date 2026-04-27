module m_MC_step
    use m_constants
    use m_tower
    use m_ran_gen
    use magnitudes
    implicit none
    contains

    subroutine MC_step(s, tries, coord, phi, energy, &
        accepted_moves, rejected_moves, move_accepted, &
        r_vector, r_prob, x_dist, y_dist)
        integer, intent(in) ::  coord(2, l_box**2)
        integer, intent(inout) :: s(l_box**2), accepted_moves, rejected_moves, tries
        real(8), intent(in) :: phi(l_box**2)
        real(8), intent(inout) :: energy
        integer :: i, j, lst_idx, rand_vec(2)
        integer, intent(out) :: x_dist, y_dist
        integer, intent(in) :: r_vector(:, :)
        real(8), intent(in) :: r_prob(:)
        real(8) :: delta_energy
        logical, intent(out) :: move_accepted

        !choosing a random site
        i = int(get_random() * l_box**2 ) + 1

        do while (s(i) == -1)
            i = int(get_random() * l_box**2) + 1
        end do


        tries = tries + 1
        

        

        !Randomly choosing a vector from the tower
        lst_idx = tower_sample(r_prob)

    
        !choosing the new site based on the random vector
        rand_vec = r_vector(:, lst_idx)
        !print *, 'Random vector choosed: ', rand_vec

        !x distance 
        x_dist = rand_vec(1)
        y_dist = rand_vec(2)

        !Applying PBC to the new site

        if (mod(i, l_box) + rand_vec(1) > l_box) then
            rand_vec(1) = rand_vec(1) - l_box
        else if (mod(i, l_box) + rand_vec(1) < 1) then
            rand_vec(1) = rand_vec(1) + l_box
        end if

        if (i + rand_vec(2) * l_box > l_box**2) then
            rand_vec(2) = rand_vec(2) - l_box
        else if (i + rand_vec(2) * l_box < 1) then
            rand_vec(2) = rand_vec(2) + l_box
        end if

        !Index of the new site

        j = i + rand_vec(1) + rand_vec(2) * l_box

        if (s(j) /= -1) then
            rejected_moves = rejected_moves + 1
            move_accepted = .false.
            return
        end if
        
        !print *, 'Random vector mod: ', rand_vec
        !print *, "Attempting move from site ", i, " to site ", j

        delta_energy = energy_change(s, x_dist, i, j, phi, coord)
       
        if (delta_energy < 0) then
            s(j) = 1
            s(i) = -1
            energy = energy + delta_energy
            accepted_moves = accepted_moves + 1
            move_accepted = .true.
        else if (get_random() < exp(-(1/temp) *delta_energy)) then
            s(j) = 1
            s(i) = -1
            energy = energy + delta_energy
            accepted_moves = accepted_moves + 1
            move_accepted = .true.

        else
            rejected_moves = rejected_moves + 1
            move_accepted = .false.
        end if
    end subroutine MC_step






    subroutine MC_time(time, tries, w_vector )
        real(8), intent(inout) :: time
        integer, intent(in) :: tries
        real(8), intent(in) :: w_vector(:)

        time = time + (tries/sum(w_vector))

    end subroutine MC_time

end module m_MC_step











