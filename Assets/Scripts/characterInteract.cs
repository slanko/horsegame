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
    // Start is called before the first frame update
    void Start()
    {
        cC = GetComponent<characterController>();
    }

    // Update is called once per frame
    void Update()
    {
        Debug.DrawRay(transform.position, cC.cam.transform.forward * interactDistance, Color.red, 0.1f, false);
        //raycasting
        if (Physics.Raycast(transform.position, cC.cam.transform.forward, out var rayHit, interactDistance, interactableLayers))
        {
            if (rayHit.collider.gameObject.tag == "horse")
            {
                horseBehaviour hB = rayHit.collider.gameObject.GetComponent<horseBehaviour>();
                targetName.text = hB.horseName;
            }
        }
        else
        {
            targetName.text = "";
        }
    }
}
