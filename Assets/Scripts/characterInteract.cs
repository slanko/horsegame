using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class characterInteract : MonoBehaviour
{
    float vert, horiz;
    public LayerMask interactableLayers;
    public float interactDistance;
    public Text targetName;
    characterController cC;
    public KeyCode interactKey;
    public horseBehaviour hB;
    // Start is called before the first frame update
    void Start()
    {
        cC = GetComponent<characterController>();
    }

    // Update is called once per frame
    void Update()
    {
        if(cC.currentState == characterController.playerState.GROUNDED || cC.currentState == characterController.playerState.JUMPING)
        {
            if (Physics.Raycast(transform.position, cC.cam.transform.forward, out var rayHit, interactDistance, interactableLayers))
            {
                if (rayHit.collider.gameObject.tag == "horse")
                {
                    hB = rayHit.collider.gameObject.GetComponent<horseBehaviour>();
                    targetName.text = hB.horseName;
                    if (Input.GetKeyDown(interactKey))
                    {
                        transform.position = hB.myRideAnchor.position;
                        transform.SetParent(hB.myRideAnchor);
                        transform.rotation = new Quaternion(0, 0, 0, 0);
                        cC.rb.constraints = RigidbodyConstraints.FreezeAll;
                        cC.myCap.enabled = false;
                        if (hB.isTamed)
                        {
                            cC.goToRide();
                        }
                        else
                        {
                            cC.goToTame();
                        }
                    }
                }
            }
            else
            {
                targetName.text = "";
            }
        }
        else
        {
            targetName.text = "";
        }

    }
}
