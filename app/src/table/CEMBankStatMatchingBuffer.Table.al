table 6086378 "CEM Bank Stat. Matching Buffer"
{
    Caption = 'Bank Statement Matching Buffer';

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; Quality; Decimal)
        {
            Caption = 'Quality';
        }
    }

    keys
    {
        key(Key1; "Line No.", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Quality)
        {
        }
    }

    fieldgroups
    {
    }


    procedure AddMatchCandidate(LineNo: Integer; EntryNo: Integer; Quality: Decimal)
    var
        BankStatementMatchingBuffer: Record "CEM Bank Stat. Matching Buffer";
    begin
        BankStatementMatchingBuffer.Init;
        BankStatementMatchingBuffer."Line No." := LineNo;
        BankStatementMatchingBuffer."Entry No." := EntryNo;
        BankStatementMatchingBuffer.Quality := Quality;
        Rec := BankStatementMatchingBuffer;
        Insert;
    end;
}

