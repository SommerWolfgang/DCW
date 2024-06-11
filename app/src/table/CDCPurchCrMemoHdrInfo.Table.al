table 6085770 "CDC Purch. Cr. Memo Hdr. Info."
{
    Caption = 'Purch. Cr. Memo DC Info.';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "Purch. Cr. Memo Hdr.";
        }
        field(3; "Approval Flow Code"; Code[10])
        {
            Caption = 'Approval Flow Code';
            TableRelation = "CDC Approval Flow";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure GetApprovalFlowCode(PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr."): Code[10]
    var
        PurchCrMemoHeaderDCInfo: Record "CDC Purch. Cr. Memo Hdr. Info.";
    begin
        if PurchCrMemoHeaderDCInfo.Get(PurchCrMemoHeader."No.") then
            exit(PurchCrMemoHeaderDCInfo."Approval Flow Code");
    end;
}

