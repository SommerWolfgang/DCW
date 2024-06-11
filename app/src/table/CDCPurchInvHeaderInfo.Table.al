table 6085769 "CDC Purch. Inv. Header Info."
{
    Caption = 'Purch. Inv. Header DC Info.';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "Purch. Inv. Header";
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


    procedure GetApprovalFlowCode(PurchInvHeader: Record "Purch. Inv. Header"): Code[10]
    var
        PurchInvHeaderDCInfo: Record "CDC Purch. Inv. Header Info.";
    begin
        if PurchInvHeaderDCInfo.Get(PurchInvHeader."No.") then
            exit(PurchInvHeaderDCInfo."Approval Flow Code");
    end;
}

