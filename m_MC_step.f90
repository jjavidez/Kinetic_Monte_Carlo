module m_MC_step
    use m_constants
    use m_tower
    use m_ran_gen
    use magnitudes
    implicit none
    contains

    subroutine MC_step(s, tries, coord, phi, energy, accepted_moves, rejected_moves, move_accepted)
        integer, intent(in) ::  coord(2, l_box**2)
        integer, intent(inout) :: s(l_box**2), accepted_moves, rejected_moves, tries
        real(8), intent(in) :: phi(l_box**2)
        real(8), intent(inout) :: energy
        integer :: i, j,  rand_num, lst_idx, rand_vec(2), dist
        integer, allocatable :: r_vector(:, :)
        real(8), allocatable :: w_vector(:), r_prob(:)
        real(8) :: delta_energy
        logical, intent(out) :: move_accepted

        !choosing a random site
        i = int(get_random() * l_box**2 + 0.5)

        do while (s(i) == -1)
            i = int(get_random() * l_box**2 + 0.5)
        end do


        tries = tries + 1

        !choosing a random vector and its corresponding probability
        call vectors(r_vector, w_vector, r_prob)
        rand_num = get_random()
        lst_idx = 0

        do i = 1, size(r_prob)
            if (rand_num < r_prob(i)) then
                lst_idx = i
                exit
            end if
        end do

        !choosing the new site based on the random vector
        rand_vec = r_vector(2, lst_idx)

        !x distance 
        dist = rand_vec(1)

        !Applying PBC to the new site

        if (i + rand_vec(1) > l_box) then
            rand_vec(1) = rand_vec(1) - l_box
        else if (i + rand_vec(1) < 1) then
            rand_vec(1) = rand_vec(1) + l_box
        end if

        if (i + rand_vec(2) * l_box > l_box**2) then
            rand_vec(2) = rand_vec(2) - l_box
        else if (i + rand_vec(2) * l_box < 1) then
            rand_vec(2) = rand_vec(2) + l_box
        end if

        !Index of the new site

        j = i + rand_vec(1) + rand_vec(2) * l_box

        !We want to move to the new site only if it is empty

        do while (s(j) == 1)

            !Applying PBC to the new site

            if (i + rand_vec(1) > l_box) then
                rand_vec(1) = rand_vec(1) - l_box
            else if (i + rand_vec(1) < 1) then
                rand_vec(1) = rand_vec(1) + l_box
            end if

            if (i + rand_vec(2) * l_box > l_box**2) then
                rand_vec(2) = rand_vec(2) - l_box
            else if (i + rand_vec(2) * l_box < 1) then
                rand_vec(2) = rand_vec(2) + l_box
            end if

            !Index of the new site

            j = i + rand_vec(1) + rand_vec(2) * l_box

        end do

        delta_energy = energy_change(s, dist, i, j, phi, coord)
       
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
        integer :: i

        time = time + (tries/sum(w_vector))

    end subroutine MC_time

end module m_MC_step











