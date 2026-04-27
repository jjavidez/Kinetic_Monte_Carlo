module m_constants
    implicit none
    
    integer,    parameter :: l_box      = 20     ! Lattice size
    integer,    parameter :: n_steps    = 10000000
    integer,    parameter :: cut_off    = 10
    integer(8), parameter :: seed       = 1234  !Seed for random number generator
    real(8)               :: temp       = 5.0d-1 !Default value of temperature
    real(8)               :: el_field
end module m_constants