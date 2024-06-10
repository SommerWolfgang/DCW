table 6086227 "CTS-CDN Profile Sel. Parameter"
{
    Caption = 'Participation Profile Relation';

    fields
    {
        field(1; "Network Name"; Text[30])
        {
            Caption = 'Network Name';
            TableRelation = "CTS-CDN Network";
        }
        field(2; "Participation Identifier Type"; Integer)
        {
            Caption = 'Participation Identifier Type';
        }
        field(3; "Participation Identifier Value"; Text[50])
        {
            Caption = 'Participation Identifier Value';
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Group,Profile';
            OptionMembers = Group,"Profile";

            trigger OnValidate()
            begin
                "Lookup Info" := '';
            end;
        }
        field(5; "Code"; Code[30])
        {
            Caption = 'Code';
            TableRelation = IF (Type = CONST(Profile)) "CTS-CDN Network Profile"."Filter Code" WHERE("Network Name" = FIELD("Network Name"))
            ELSE
            IF (Type = CONST(Group)) "CTS-CDN Network Profile Group".Code WHERE("Network Name" = FIELD("Network Name"));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                NetworkProfile: Record "CTS-CDN Network Profile";
                NetworkProfileGroup: Record "CTS-CDN Network Profile Group";
                ProfileID: Integer;
            begin
                if Type = Type::Group then begin
                    if NetworkProfileGroup.Get("Network Name", Code) then begin
                        Description := NetworkProfileGroup.Description;
                    end;
                end else
                    if Evaluate(ProfileID, Code) then
                        if NetworkProfile.Get(ProfileID) then
                            Description := NetworkProfile.Description;

                "Lookup Info" := '';
            end;
        }
        field(6; Description; Text[250])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(10; "Profile Direction"; Option)
        {
            Caption = 'Profile Direction';
            OptionCaption = 'Outbound,Inbound,Both';
            OptionMembers = Outbound,Inbound,Both;
        }
        field(11; "Document Category"; Code[20])
        {
            Caption = 'Document Category';
        }
        field(30; "Lookup Info"; Text[250])
        {
            Caption = 'More information';
        }
    }

    keys
    {
        key(Key1; "Network Name", "Participation Identifier Type", "Participation Identifier Value", Type, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Network Name" = 'peppol' then
            SetProfileDirFromLicense;
    end;

    var
        GroupAlreadyRegMsg: Label 'Profiles already registered. Drilldown for more information.';
        ProfileAlreadyRegMsg: Label 'This profile is already registered. Drilldown for more information.';


    procedure GetParticipation(var CDNParticipation: Record "CTS-CDN Participation")
    begin
        CDNParticipation.SetRange("Network Name", "Network Name");
        CDNParticipation.SetRange("Identifier Type ID", "Participation Identifier Type");
        CDNParticipation.SetRange("Identifier Value", "Participation Identifier Value");
        CDNParticipation.FindFirst;
    end;


    procedure LoadFromParticipation(var Participation: Record "CTS-CDN Participation" temporary)
    var
        NetworkProfile: Record "CTS-CDN Network Profile";
        NetworkProfileGroup: Record "CTS-CDN Network Profile Group";
        ParticipProfileRel: Record "CTS-CDN Particip. Profile Rel.";
        DocCatCode: Code[20];
        ProfileDirection: Integer;
    begin
        // Load Profiles
        // First the groups

        Participation.FilterProfileRelations(ParticipProfileRel);
        ParticipProfileRel.SetRange(Disabled, 0DT);

        NetworkProfileGroup.SetRange("Network Name", Participation."Network Name");
        if NetworkProfileGroup.FindSet then
            repeat
                NetworkProfileGroup.CalcFields("No. of Profiles");
                ParticipProfileRel.CalcFields("Profile Group Code");
                ParticipProfileRel.SetRange("Profile Group Code", NetworkProfileGroup.Code);
                if ParticipProfileRel.FindFirst then begin
                    DocCatCode := ParticipProfileRel."DC Document Category";
                    ProfileDirection := ParticipProfileRel."Profile Direction";
                    ParticipProfileRel.SetRange("DC Document Category", DocCatCode);
                    ParticipProfileRel.SetRange("Profile Direction", ProfileDirection);

                    if ParticipProfileRel.Count = NetworkProfileGroup."No. of Profiles" then
                        CreateProfileSelection(Participation, NetworkProfileGroup.Code, DocCatCode, NetworkProfileGroup.Description,
                          ProfileDirection, true);
                end;
            until NetworkProfileGroup.Next = 0;

        // Then the profiles
        ParticipProfileRel.SetRange("Profile Group Code");
        ParticipProfileRel.SetRange("DC Document Category");
        ParticipProfileRel.SetRange("Profile Direction");

        if ParticipProfileRel.FindSet then
            repeat
                Participation.FilterProfileSelections(Rec);
                SetRange(Type, Type::Group);
                ParticipProfileRel.CalcFields("Profile Group Code");
                SetRange(Code, ParticipProfileRel."Profile Group Code");
                SetRange("Profile Direction", ParticipProfileRel."Profile Direction");

                if IsEmpty then begin
                    NetworkProfile.Get(ParticipProfileRel."Profile System ID");
                    CreateProfileSelection(Participation, Format(ParticipProfileRel."Profile System ID"),
                      ParticipProfileRel."DC Document Category", NetworkProfile.Description, ParticipProfileRel."Profile Direction", false);
                end;

            until ParticipProfileRel.Next = 0;

        Reset;
    end;

    local procedure CreateProfileSelection(var CDNParticipation: Record "CTS-CDN Participation"; NewCode: Code[30]; DocCatCode: Code[20]; NewDescription: Text[250]; NewProfileDirection: Integer; Group: Boolean)
    begin
        Rec.Init;
        Rec."Network Name" := CDNParticipation."Network Name";
        Rec."Participation Identifier Type" := CDNParticipation."Identifier Type ID";
        Rec."Participation Identifier Value" := CDNParticipation."Identifier Value";
        if Group then
            Rec.Type := Rec.Type::Group
        else
            Rec.Type := Rec.Type::Profile;

        Rec.Description := NewDescription;
        Rec.Validate(Code, NewCode);
        Rec."Profile Direction" := NewProfileDirection;
        Rec."Document Category" := DocCatCode;
        Rec.Insert;
    end;


    procedure GetDisplayName(): Text[1024]
    var
        NetworkProfile: Record "CTS-CDN Network Profile";
        NetworkProfileGroup: Record "CTS-CDN Network Profile Group";
        ProfileId: Integer;
    begin
        if Type = Type::Group then begin
            NetworkProfileGroup.Get("Network Name", Code);
            exit(NetworkProfileGroup.Description);
        end else begin
            Evaluate(ProfileId, Code);
            NetworkProfile.Get(ProfileId);
            exit(NetworkProfile.Description);
        end;
    end;


    procedure SetProfileDirFromLicense()
    var
        LicenseMgt: Codeunit "CTS-CDN License Mgt.";
    begin
        case true of
            LicenseMgt.HasLicenseAccessToDC and LicenseMgt.HasLicenseAccessToDO:
                "Profile Direction" := "Profile Direction"::Both;
            LicenseMgt.HasLicenseAccessToDC and not LicenseMgt.HasLicenseAccessToDO:
                "Profile Direction" := "Profile Direction"::Inbound;
            not LicenseMgt.HasLicenseAccessToDC and LicenseMgt.HasLicenseAccessToDO:
                "Profile Direction" := "Profile Direction"::Outbound;
        end;
    end;


    procedure CheckRegisteredProfiles(NetworkName: Text[30]; var APNetworkProfiles: Record "CTS-CDN AP Network Profile" temporary)
    var
        NetworkProfile: Record "CTS-CDN Network Profile";
        ProfileID: Integer;
        RegisteredProfiles: Text[1024];
    begin
        SetFilter("Profile Direction", '%1|%2', "Profile Direction"::Inbound, "Profile Direction"::Both);
        if FindSet then
            repeat
                if Type = Type::Profile then begin
                    Evaluate(ProfileID, Code);
                    APNetworkProfiles.SetRange("Network Profile ID", ProfileID);
                    if not APNetworkProfiles.IsEmpty then begin
                        Validate("Lookup Info", ProfileAlreadyRegMsg);
                        Modify;
                    end;
                end else begin
                    NetworkProfile.SetRange("Network Name", NetworkName);
                    NetworkProfile.SetRange("Network Profile Group Code", Code);
                    if NetworkProfile.FindSet then
                        repeat
                            APNetworkProfiles.SetRange("Network Profile ID", NetworkProfile."System ID");
                            if not APNetworkProfiles.IsEmpty then begin
                                if RegisteredProfiles = '' then
                                    RegisteredProfiles := NetworkProfile.Description
                                else
                                    RegisteredProfiles += ', ' + NetworkProfile.Description;
                            end;
                        until NetworkProfile.Next = 0;

                    Validate("Lookup Info", StrSubstNo(GroupAlreadyRegMsg, RegisteredProfiles));
                    Modify;

                end;
            until Next = 0;
    end;
}

