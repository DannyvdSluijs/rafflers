        >>source format is free
identification division.
    program-id. domcode-raffler.
    author. Lucas van Lierop.
      *> =============================================
      *> 1) read a file and pick a name for the raffle
      *> =============================================
      *> usage: ./raffler {filename}
      *> =============================================

environment division.
    input-output section.
       file-control.
           select names-file
               assign to names-file-name
               file status is names-file-status
               organization is line sequential.

data division.
    file section.
        fd names-file.
        01 names-record             pic x(80).

    working-storage section.
        01 names-file-name          pic x(50).
        01 names-file-status        pic x(2).
        01 current-name-nr          pic 9(9) value zero.

        01 name-columns.
        03 name                     pic x(32).

        01 nr-of-names              pic 9(3).
        01 nr-of-names-formatted    pic zzz.
        01 random-name-nr           pic 9(3) value zero.

procedure division.
    perform 100-initialize.
    perform 110-read-input-file.
    perform 120-pick-winner.
    perform 130-lookup-winner-name.

stop run.

100-initialize.
    accept names-file-name from argument-value
        on exception
            display
                "attempt to read beyond end of command line"
                upon syserr
            end-display
    end-accept.

110-read-input-file.
    open input names-file

    read names-file

    perform until names-file-status = '10'
       add 1 to nr-of-names

       read names-file
    end-perform

    close names-file.


120-pick-winner.
    move nr-of-names to nr-of-names-formatted

    call "calcrand"
      using nr-of-names
            random-name-nr
    end-call
.

130-lookup-winner-name.
    open input names-file

    read names-file

    perform until current-name-nr = nr-of-names
       add 1 to current-name-nr

       unstring names-record delimited by ',' into
           name

        if current-name-nr = random-name-nr then
           display
              name "(" random-name-nr "/" nr-of-names ")"
          end-display
        end-if

       read names-file
    end-perform

    close names-file
.
