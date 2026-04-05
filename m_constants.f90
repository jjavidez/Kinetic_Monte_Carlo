module m_constants
    implicit none
    

    real(8),    parameter :: temp       = 5.0d-1   ! Kelvin
    integer,    parameter :: l_box      = 20      ! Lattice size
    integer,    parameter :: n_steps    = 10000
    integer,    parameter :: cut_off    = 10
    real(8),    parameter :: el_field   = 5.0d-2   ! Electric field strength
    integer(8), parameter :: seed       = 12345 ! Seed for random number generator
    

end module m_constants