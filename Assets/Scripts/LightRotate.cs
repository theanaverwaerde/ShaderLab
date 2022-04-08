using UnityEngine;

[ExecuteInEditMode]
public class LightRotate : MonoBehaviour
{
    [SerializeField] private bool play;
    [SerializeField] private float speed = 1;
    
    void Update()
    {
        if (!play)
        {
            return;
        }
        
        transform.RotateAround(Vector3.up, speed * Time.deltaTime);
    }
}
